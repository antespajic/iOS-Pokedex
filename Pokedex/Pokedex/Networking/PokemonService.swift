//
//  PokemonService.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 25/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import CodableAlamofire

final class PokemonService {
    
    private let headers: HTTPHeaders!
    
    private init?() {
        guard let authHeader = UserSession.sharedInstance.authHeader else { return nil }
        
        self.headers = [
            "Authorization": authHeader
        ]
    }
    
    static func getAll() -> Observable<[Pokemon]> {
        
        
        return Observable.create { observer in
            let request = Alamofire
                .request(APIConstants.apiURL + "/pokemons",
                        method: .get,
                        headers: headers
                )
                .validate()
                .responseDecodableObject(keyPath: "data") { (response: DataResponse<[Pokemon]>) in
                    switch response.result {
                    case .success(let pokemons):
                        observer.onNext(pokemons)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func createPokemon(name: String, height: String, weight: String, type: String, description: String, pokemonImage: UIImage?) -> Observable<Pokemon?> {
        
        let attributes = [
            "name": name,
            "height": height,
            "weight": weight,
            "order":"19", // read these from type?
            "is_default":"1",
            "gender_id":"1",
            "base_experience":"30",
            "description": description
        ]
        
        return Observable.create { observer in
            Alamofire
            .upload(multipartFormData: { multipartFormData in
                if let image = pokemonImage {
                    multipartFormData.append(UIImagePNGRepresentation(image)!,
                                             withName: "data[attributes][image]",
                                             fileName: "image.png",
                                             mimeType: "image/png")
                }

                for (key, value) in attributes {
                    multipartFormData.append(value.data(using: .utf8)!, withName: "data[attributes][" + key + "]")
                }
            }, to: APIConstants.apiURL + "/pokemons", method: .post, headers: headers) { result in
                switch result {
                case .success(let uploadRequest, _, _):
                    uploadRequest.responseDecodableObject(keyPath: "data") { (response: DataResponse<Pokemon>) in
                        switch response.result {
                        case .success(let pokemon):
                            observer.onNext(pokemon)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    observer.onError(encodingError)
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func getPokemon(withId id:String) -> Observable<Pokemon?> {
        
        return Observable.create { observer in
            let request =
                Alamofire
                    .request(APIConstants.apiURL + "/pokemons/\(id)", method: .get, headers: headers)
                    .validate()
                    .responseDecodableObject(keyPath: "data") { (response: DataResponse<Pokemon>) in
                        switch response.result {
                        case .success(let pokemon):
                            observer.onNext(pokemon)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func getComments(forPokemonId id: String) -> Observable<[Comment]> {
        
        return Observable.create{ observer in
            
            let request = Alamofire
                .request(APIConstants.apiURL + "/pokemons/\(id)/comments", method: .get, headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data"){ (response: DataResponse<[Comment]>) in
                    switch response.result {
                    case .success(let comments):
                        observer.onNext(comments)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create{
                request.cancel()
            }
        }
        
    }

}

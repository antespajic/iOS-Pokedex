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
    
    private init() {
        
    }
    
    static func getAll() -> Observable<[Pokemon]> {
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just([]) }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader
        ]
        
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
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just(nil) }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader
        ]
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
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just(nil) }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader
        ]
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
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just([]) }
        
        let headers: HTTPHeaders = [ "Authorization": authHeader ]
        
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
    
    static func upvotePokemon(withId id: String) {
        guard let authHeader = UserSession.sharedInstance.authHeader else { return }
        let headers: HTTPHeaders = [ "Authorization": authHeader ]
        
        Alamofire.request(APIConstants.apiURL + "/pokemons/\(id)/upvote", method: .post, headers: headers)
    }

    static func downvotePokemon(withId id: String) {
        guard let authHeader = UserSession.sharedInstance.authHeader else { return }
        let headers: HTTPHeaders = [ "Authorization": authHeader ]
        
        Alamofire.request(APIConstants.apiURL + "/pokemons/\(id)/downvote", method: .post, headers: headers)
    }
    
    static func commentOnPokemon(withId id: String, comment: String) -> Observable<Comment?> {
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just(nil) }
        let headers: HTTPHeaders = [ "Authorization": authHeader ]
        
        let params = [
            "data": [
                "attributes": [
                    "content": comment
                ]
            ]
        ]
        return Observable.create{ observer in
            let request = Alamofire.request(APIConstants.apiURL + "/pokemons/\(id)/comments",
                method: .post,
                parameters: params,
                headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data"){ (response: DataResponse<Comment>) in
                    switch response.result {
                    case .success(let comment):
                        observer.onNext(comment)
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
}

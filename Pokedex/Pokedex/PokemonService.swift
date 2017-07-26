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

class PokemonService {
    
    private init() {}
    
    static func getAll() -> Observable<[Pokemon]> {
        
        guard let authHeader = UserSession.sharedInstance.authHeader else { return Observable.just([]) }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader
        ]
        
        return Observable.create { observer in
            let request = Alamofire
                .request(APIConstants.baseURL + "/pokemons",
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
}

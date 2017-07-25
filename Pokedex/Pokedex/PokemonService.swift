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
    
    private struct PokemonResponse: Codable {
        let data: [Pokemon]?
    }
    
    static func getAll() -> Observable<[Pokemon]> {
        
        return Observable.create { observer in
            let request = Alamofire
                .request(APIConstants.baseURL + "/pokemons",
                         method: .get)
                .validate()
                .responseDecodableObject { (response: DataResponse<PokemonResponse>) in
                    switch response.result {
                    case .success(let pokeResponse):
                        observer.onNext(pokeResponse.data ?? [])
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

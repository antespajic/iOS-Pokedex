//
//  UserService.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 18/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import RxSwift

class UserService {
    
    private init() {}
    
    static func register(email: String, username: String, password: String, confirmationPassword: String) -> Observable<User?> {
        let params = [
            "data": [
                "type": "users",
                "attributes": [
                    "email": email,
                    "username": username,
                    "password": password,
                    "confirmation_password": confirmationPassword
                ]
            ]
        ]
        
        return Observable.create { observer in
            let request = Alamofire
                .request(
                    APIConstants.apiURL + "/users",
                    method: .post,
                    parameters: params,
                    encoding: JSONEncoding.default
                )
                .validate()
                .responseDecodableObject {(response: DataResponse<User>) in
                    switch response.result {
                    case .success(let user):
                        observer.onNext(user)
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

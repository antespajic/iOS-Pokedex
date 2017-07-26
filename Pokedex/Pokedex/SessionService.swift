//
//  LoginService.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 18/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import RxSwift

class SessionService {
    
    private init() {}
    
    static func login(email: String, password: String) -> Observable<User?> {
        let params = [
            "data" : [
                "type": "session",
                "attributes": [
                    "email": email,
                    "password": password
                ]
            ]
        ]
        
        return Observable.create { observer in
            
            let request = Alamofire
                .request(
                    APIConstants.baseURL + "/users/login",
                    method: .post,
                    parameters: params,
                    encoding: JSONEncoding.default
                )
                .validate()
                .responseDecodableObject { (response: DataResponse<User>) in
                    switch response.result {
                    case .success(let user):
                        observer.onNext(user)
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
    
    static func logout() -> Observable<Result<Any>> {
        guard let authHeader = UserSession.sharedInstance.authHeader
            else {
            return Observable.just(
                        Result.failure(
                            NSError(domain: "Error", code: 453, userInfo: ["Description" : "No auth header"])
                        )
                    )
            }
        
        let headers: HTTPHeaders = [
            "Authorization": authHeader
        ]
        
        return Observable.create { observer in
            
            let request = Alamofire
                .request(
                    APIConstants.baseURL + "/users/logout",
                    method: .delete,
                    headers: headers
                )
                .validate()
                .responseJSON { response in
                    observer.onNext(response.result)
                    observer.onCompleted()
                }
            
            return Disposables.create{
                request.cancel()
            }
        }
        
    }
    
}

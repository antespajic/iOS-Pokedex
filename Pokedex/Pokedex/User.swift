//
//  UserModel.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 18/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation

struct User: Codable {
    
    private struct DataAttributes: Codable {
        let email: String
        let username: String
        let authToken: String
        
        enum CodingKeys: String, CodingKey {
            case authToken = "auth-token"
            case email
            case username
        }
    }
    
    private struct UserData: Codable {
        let id: String
        let attributes: DataAttributes
    }
    
    // MARK: - JSON properties -
    private let data: UserData
    
    // MARK: - Helpers -
    var id: String { return data.id }
    var email: String  { return data.attributes.email }
    var username: String  { return data.attributes.username }
    var authToken: String  { return data.attributes.authToken }
}

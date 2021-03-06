//
//  UserSession.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 25/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation

class UserSession {
    static let sharedInstance = UserSession()
    
    private(set) var authHeader: String?
    
    private init() {}
    
    func createAuthHeader(authToken: String?, email: String) {
        guard let token = authToken else { return }
        self.authHeader = "Token token=" + token + ", email=" + email
    }
    
    func clearAuthHeader() {
        self.authHeader = Optional.none
    }
    
}

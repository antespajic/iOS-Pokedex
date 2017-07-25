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
    
    var authToken: String?
    
    private init() {}
}

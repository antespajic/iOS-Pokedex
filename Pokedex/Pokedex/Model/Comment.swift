//
//  Comment.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 02/08/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let id: String
    let type: String
    
    // JSON api standard is the worst standard ever...
    
    private struct DataAttributes: Codable {
        let content: String
        let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case createdAt = "created-at"
            case content
        }
    }
    
    private struct RelationshipAttributes: Codable {
        let author: AuthorRelationship
       
    }
    
    private struct AuthorRelationship: Codable {
        let data: AuthorData
    }
    
    private struct AuthorData: Codable {
        let id: String
        let type: String
    }
    
    private let attributes: DataAttributes
    private let relationships: RelationshipAttributes
    
    var content: String { return attributes.content }
    var createdAt: String { return attributes.createdAt }
    var authorId: String { return relationships.author.data.id }
}

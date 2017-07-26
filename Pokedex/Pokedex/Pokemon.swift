//
//  Pokemon.swift
//  Pokedex
//
//  Created by Infinum Student Academy on 25/07/2017.
//  Copyright © 2017 Ante Spajić. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    
    private struct DataAttributes: Codable {
        let name: String
        let baseExperience: Int?
        let isDefault: Bool?
        let order: Int
        let height: Double
        let weight: Double
        let createdAt: String
        let updatedAt: String
        let imageUrl: String?
        let description: String
        let totalVoteCount: Int
        let votedOn: Int
        let gender: String
        
        enum CodingKeys: String, CodingKey {
            case baseExperience = "base-experience"
            case isDefault = "is-default"
            case createdAt = "created-at"
            case updatedAt = "updated-at"
            case imageUrl = "image-url"
            case totalVoteCount = "total-vote-count"
            case votedOn = "voted-on"
            case name
            case order
            case height
            case weight
            case description
            case gender
        }
    }
    
    private let id: String
    private let type: String
    private let attributes: DataAttributes
    
    var name: String { return attributes.name }
    var baseExperience: Int? { return attributes.baseExperience }
    var isDefault: Bool? { return attributes.isDefault }
    var order: Int { return attributes.order }
    var height: Double { return attributes.height }
    var weight: Double { return attributes.weight }
    var createdAt: String { return attributes.createdAt }
    var updatedAt: String { return attributes.updatedAt }
    var imageUrl: String? { return attributes.imageUrl }
    var description: String { return attributes.description }
    var totalVoteCount: Int { return attributes.totalVoteCount }
    var votedOn: Int { return attributes.votedOn }
    var gender: String { return attributes.gender }
}

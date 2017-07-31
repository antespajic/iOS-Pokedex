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
        let order: Int
        let height: Double
        let weight: Double
        let imageUrl: String?
        let description: String
        let gender: String
        
        enum CodingKeys: String, CodingKey {
            case imageUrl = "image-url"
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
    var order: Int { return attributes.order }
    var height: Double { return attributes.height }
    var weight: Double { return attributes.weight }
    var imageUrl: String? { return attributes.imageUrl }
    var description: String { return attributes.description }
    var gender: String { return attributes.gender }
}

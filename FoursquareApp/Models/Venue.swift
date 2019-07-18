//
//  Venue.swift
//  FoursquareApp
//
//  Created by olli on 18.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

struct APIAnswer: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    let response: VenueAnswer?
    
    struct VenueAnswer: Decodable {
        enum CodingKeys: String, CodingKey {
            case venues
        }
        
        let venues: [Venue]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.venues = try container.decode([Venue].self, forKey: .venues)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decode(VenueAnswer.self, forKey: .response)
    }
}

struct Venue: Decodable {
    let id: String
    let name: String
    let location: Location
    let categoryName: String
    let checkins: Int
    
    struct Category: Decodable {
        let shortName: String
        
        enum CodingKeys: String, CodingKey {
            case shortName
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.shortName = try container.decode(String.self, forKey: .shortName)
        }
    }
    
    struct Stats: Decodable {
        let checkinsCount: Int
        
        enum CodingKeys: String, CodingKey {
            case checkinsCount
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.checkinsCount = try container.decode(Int.self, forKey: .checkinsCount)
        }
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case categories = "categories"
        case stats = "stats"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.location = try container.decode(Location.self, forKey: .location)
        let categories = try container.decode([Category].self, forKey: .categories)
        self.categoryName = categories.first?.shortName ?? ""
        let stats = try container.decode(Stats.self, forKey: .stats)
        self.checkins = stats.checkinsCount
    }
}

//
//  FoursquareModels.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let lat: Double?
    let lng: Double?
    let distance: Double?
    let countryCode: String?
    let country: String?
    let state: String?
    let city: String?
    let streetAddress: String?
    let crossStreet: String?
    let postalCode: String?
    var coordinate: Coordinate? {
        guard let latitude = lat, let longitude = lng else { return nil }
        return Coordinate(latitude: latitude, longitude: longitude)
    }
    
    enum MainKeys: String, CodingKey {
        case lat
        case lng
        case distance
        case countryCode = "cc"
        case country
        case state
        case city
        case streetAddress = "address"
        case crossStreet
        case postalCode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainKeys.self)
        
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lng = try container.decode(Double.self, forKey: .lng)
        
        self.distance = try? container.decode(Double.self, forKey: .distance)
        self.countryCode = try? container.decode(String.self, forKey: .countryCode)
        self.country = try? container.decode(String.self, forKey: .country)
        self.state = try? container.decode(String.self, forKey: .state)
        self.city = try? container.decode(String.self, forKey: .city)
        self.streetAddress = try? container.decode(String.self, forKey: .streetAddress)
        self.crossStreet = try? container.decode(String.self, forKey: .crossStreet)
        self.postalCode = try? container.decode(String.self, forKey: .postalCode)
    }
    
}

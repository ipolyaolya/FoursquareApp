//
//  VenuesEndpoint.swift
//  FoursquareApp
//
//  Created by olli on 18.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

enum VenueEndpoint: Endpoint {
    case search(clientID: String, clientSecret: String, coordinate: Coordinate, category: FoodLocation, query: String?, searchRadius: Int?, limit: Int?)
    
    
    // MARK: Venue Endpoint - Endpoint
    var baseURL: String {
        return "https://api.foursquare.com"
    }
    
    var path: String {
        switch self {
        case .search: return "/v2/venues/search"
        }
    }
    
    fileprivate struct ParameterKeys {
        static let clientID = "client_id"
        static let clientSecret = "client_secret"
        static let version = "v"
        static let category = "categoryId"
        static let location = "ll"
        static let query = "query"
        static let limit = "limit"
        static let searchRadius = "radius"
    }
    
    fileprivate struct DefaultValues {
        static let version = "20160301"
        static let limit = "50"
        static let searchRadius = "100000000000"
    }
    
    var parameters: [String : AnyObject] {
        switch self {
        case .search(let clientID, let clientSecret, let coordinate, let category, let query, let searchRadius, let limit):
            
            var parameters: [String: AnyObject] = [
                ParameterKeys.clientID: clientID as AnyObject,
                ParameterKeys.clientSecret: clientSecret as AnyObject,
                ParameterKeys.version: DefaultValues.version as AnyObject,
                ParameterKeys.location: coordinate.description as AnyObject,
                ParameterKeys.category: category.toFourSquareID() as AnyObject
            ]
            
            if let searchRadius = searchRadius {
                parameters[ParameterKeys.searchRadius] = searchRadius as AnyObject?
            } else {
                parameters[ParameterKeys.searchRadius] = DefaultValues.searchRadius as AnyObject?
            }
            
            if let limit = limit {
                parameters[ParameterKeys.limit] = limit as AnyObject?
            } else {
                parameters[ParameterKeys.limit] = DefaultValues.limit as AnyObject?
            }
            
            if let query = query {
                parameters[ParameterKeys.query] = query as AnyObject?
            }
            
            return parameters
        }
    }
}

//
//  Endpoint.swift
//  FoursquareApp
//
//  Created by olli on 18.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: AnyObject] { get }
}

extension Endpoint {
    var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
    }
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
}

enum Foursquare: Endpoint {
    case venues(VenueEndpoint)
    
    // MARK: Foursquare - Endpoint
    var baseURL: String {
        switch self {
        case .venues(let endpoint):
            return endpoint.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .venues(let endpoint):
            return endpoint.path
        }
    }
    
    var parameters: [String : AnyObject] {
        switch self {
        case .venues(let endpoint):
            return endpoint.parameters
        }
    }
}

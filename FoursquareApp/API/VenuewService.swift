//
//  VenuewService.swift
//  FoursquareApp
//
//  Created by olli on 18.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation
import Alamofire

class VenuesService {
    
    let clientID: String
    let clientSecret: String
    
    init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    func fetchLocationsFor(_ location: Coordinate, category: FoodLocation, query: String? = nil, searchRadius: Int? = nil, limit: Int? = nil, completion: (([Venue]?) -> Void)?) {
        let searchEndpoint = VenueEndpoint.search(clientID: self.clientID, clientSecret: self.clientSecret, coordinate: location, category: category, query: query, searchRadius: searchRadius, limit: limit)
        let endpoint = Foursquare.venues(searchEndpoint)
        
        Alamofire.request(endpoint.request).responseJSON { response in
            guard let data = response.data, let result = try? JSONDecoder().decode(APIAnswer.self, from: data) else {
                completion?(nil)
                return
            }
            
            completion?(result.response?.venues)
        }
    }
}

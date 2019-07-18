//
//  LocationType.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

enum FoodLocation: Int, CaseIterable {
    case cafesAndRestaurants
    
    func toFourSquareID() -> String {
        switch self {
        case .cafesAndRestaurants: return "4d4b7105d754a06374d81259"
        }
    }
}

extension FoodLocation: CustomStringConvertible {
    var description: String {
        switch self {
        case .cafesAndRestaurants: return "Cafes and restaurants"
        }
    }
}

public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}

extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}

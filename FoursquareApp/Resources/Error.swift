//
//  Error.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

func createError(domain: String, code: Int, message: String, comment: String = "") -> NSError {
    let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString(message, comment: comment)]
    return NSError(domain: domain, code: code, userInfo: userInfo)
}
 

//
//  CustomAlert.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit

func showAlert(target: UIViewController, title: String, message: String? = nil, style: UIAlertController.Style = .alert, actionList:[UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)] ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    for action in actionList {
        alert.addAction(action)
    }
    // Check to see if the target viewController current is currently presenting a ViewController
    if target.presentedViewController == nil {
        target.present(alert, animated: true, completion: nil)
    }
}
 

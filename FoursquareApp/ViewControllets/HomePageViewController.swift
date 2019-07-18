//
//  ViewController.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    let gradientLayer = CAGradientLayer()
    
    let data = FoodLocation.allCases.map { $0.description }
    
    var userSelection: FoodLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        navigationController?.navigationBar.barStyle = .black
        userSelection = FoodLocation(rawValue: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        setBlueGradientBackground()
    }
    
    func setup() {
        backgroundView.layer.addSublayer(gradientLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func transitionToSearch() {
        if let userSelection = userSelection {
            let vc = storyboard?.instantiateViewController(withIdentifier: LocationResultsViewController.storyboardIdentifier) as! LocationResultsViewController
            
            vc.searchItem = userSelection
            vc.navigationItem.title = userSelection.description
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 255.0/255.0, green: 228.0/255.0, blue: 196.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }

}

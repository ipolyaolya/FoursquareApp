//
//  LocationResultsViewController.swift
//  FoursquareApp
//
//  Created by olli on 17.07.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class LocationResultsViewController: UIViewController {
    
    public static let storyboardIdentifier: String = "LocationResultsViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinate: Coordinate?
    
    let venuesService = VenuesService(clientID: "L0UFHOAA2UGLJF3GUFVQWJFH4YUVCU54NQIAKYHRZPA2N0D4", clientSecret: "PVB5KHOMPYZ02UBDEE5YQJVVELQNA3CS30YOPMGUDZPZJTYC")
    let manager = LocationManager()
    
    var regionHasBeenSet = false
    
    var searchItem: FoodLocation?
    
    var venues: [Venue] = [] {
        didSet {
            if venues.count > 0 {
                collectionView.reloadData()
                addMapAnnotations()
            } else {
                if let searchItem = searchItem {
                    let action = UIAlertAction(title: "Search For Something Else", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    showAlert(target: self, title: "Unable to find a \(searchItem.description) near you", message: "Try looking again in a different area", style: .alert, actionList: [action])
                }
                
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchItem = FoodLocation(rawValue: 0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.6)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        manager.getPermission()
        manager.onLocationFix = { [weak self] coordinate in
            
            self?.coordinate = coordinate
            guard let searchItem = self?.searchItem else {
                return
            }
            
            self?.venuesService.fetchLocationsFor(coordinate, category: searchItem){ result in
                guard let venues = result else { return }
                self?.venues = venues
            }
        }
    }
}


extension LocationResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCollectionViewCell
        let venue = venues[indexPath.row]
        cell.locationLabel.text = venue.name
        cell.categoryLabel.text = venue.categoryName
        cell.checkinsLabel.text = "\(venue.checkins) Check-ins"
        cell.addressLabel.text = "\(venue.location.streetAddress!), \(venue.location.city!)"
        return cell
    }
    

    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            
            setMapRegion(for: venues[indexPath.row])
        }
    }
    
    
}

// MARK: MKMAPViewDelegate

extension LocationResultsViewController: MKMapViewDelegate {
    
    func addMapAnnotations() {
        removeMapAnnotations()
        
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map { venue in
                let point = MKPointAnnotation()
                
                if let coordinate = venue.location.coordinate {
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    point.title = venue.name
                    point.subtitle = "\(venue.checkins) Check-ins"
                }
                return point
            }
            mapView.addAnnotations(annotations)
            setMapRegion(for: venues.first!)
        }
    }
    
    func removeMapAnnotations() {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func setMapRegion(for venue: Venue) {
        guard let coordinate = venue.location.coordinate else { return }
        
        var region = MKCoordinateRegion()
        let clcoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        region.center = clcoordinate
        region.span.latitudeDelta = 0.03
        region.span.longitudeDelta = 0.03
        mapView.setRegion(region, animated: false)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !regionHasBeenSet {
            regionHasBeenSet = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotations = view.annotation?.title, let title = annotations else { return }
        let item = venues.firstIndex { $0.name == title }
        
        if let item = item {
            collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotations = view.annotation?.title, let title = annotations else { return }
        let item = venues.firstIndex { $0.name == title }
        
        if let item = item {
            collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
}





//
//  MapViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    //outlet
    @IBOutlet var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var attendedUser = [User]()
    let currentTrackingSection = TrackingSection()
    var currentUser: User?
    var currentSection: TrackingSection?
    let loginClient = LoginClient()
    var locationManager : CLLocationManager!
    let user = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        let workSaiGon = MKPointAnnotation()
        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20
        locationManager.requestWhenInUseAuthorization()
        
        
        loginClient.getUserInfo({ (user: User) in
            let tempAnnotation: MKPointAnnotation!
            if user.longtitude != nil && user.latitude != nil {
                tempAnnotation = MKPointAnnotation()

                tempAnnotation.coordinate = CLLocationCoordinate2DMake(user.longtitude!,user.latitude!)
                let str = String(tempAnnotation.coordinate.longitude) +  "-" + String(tempAnnotation.coordinate.latitude)
                print(str)
                tempAnnotation.title = str
                print(tempAnnotation.coordinate)
                self.addAnnotationAtCoordinate(tempAnnotation.coordinate, name: user.name!)
                
            }
        }, phone: user!.phoneNumber!)
    }

    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }

    @IBAction func logoutTapped(sender: AnyObject) {
        loginClient.logout()
    }


}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            
        }
        //let coordinateString = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        //let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        //imageView.image = annotation!.thumnail
        
        return annotationView
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            let userRef = loginClient.getRefFirebaseByPhoneNumber((user?.phoneNumber)!)
            let longtitude = ["longtitude": location.coordinate.longitude]
            let latitude = ["latitude": location.coordinate.latitude]
            userRef.updateChildValues(latitude)
            userRef.updateChildValues(longtitude)
            
        }
    }
    
    
}






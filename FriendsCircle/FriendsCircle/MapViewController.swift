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
    @IBOutlet var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    var attendedUser = [User]()
    var currentTrackingSection = TrackingSection()
    var currentUser = User.currentUser
    var currentSection: TrackingSection?
    let loginClient = LoginClient()
    var locationManager : CLLocationManager!
    var phoneNumber = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentSection = TrackingSection()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        getUserInforAndLoadAnnotations()
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
    
    func createAnnotation(user: User) {
        if user.longtitude != nil && user.latitude != nil {
            let coor = CLLocationCoordinate2D(latitude: user.latitude!,longitude: user.longtitude!)
            self.addAnnotationAtCoordinate(coor, name: user.name!)
            
            
        }
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
            //let coordinateString = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
            
        } else {
            annotationView?.annotation = annotation
        }
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
            mapView.setRegion(region, animated: true)
            
            let userRef = loginClient.getRefFirebaseByPhoneNumber((currentUser!.phoneNumber)!)
            let longtitude = ["longtitude": location.coordinate.longitude]
            let latitude = ["latitude": location.coordinate.latitude]
            
            userRef.updateChildValues(latitude)
            userRef.updateChildValues(longtitude)
        }
    }
    
    func getUserInforAndLoadAnnotations() {
        // get informaiton of current user: session id
        self.loginClient.getUserInfo((self.currentUser?.phoneNumber)!, success: { (user: User) in
            
                self.currentUser = user
                
                //get information of current session
                self.loginClient.getSessionByID((self.currentUser?.sessionId)!) { (tracking: TrackingSection) in
                    
                    self.currentTrackingSection = tracking
                    //self.currentTrackingSection.createLocalNotification()
                    for user in self.currentTrackingSection.attendUser {
                        self.phoneNumber.append(user.phoneNumber!)
                        
                    }
                    self.loginClient.getListUsersByNumbers(self.phoneNumber) { (users: [User]) in
                        self.attendedUser = users
                        if self.mapView?.annotations != nil { self.mapView.removeAnnotations(self.mapView.annotations as [MKAnnotation]) }
                        for us in users {
                            if us.phoneNumber != self.currentUser?.phoneNumber {
                                if us.longtitude != nil && us.latitude != nil {
                                    let isLocal = CLLocationCoordinate2D(latitude: us.latitude!, longitude: us.longtitude!)
                                    let time = self.currentSection!.timingCalculation(isLocal, destination: (self.currentTrackingSection.destination?.coordinate)!)
                                    print(time)
                                    self.createAnnotation(us)
                                }
                            }
                        }
                    }
                }
            }, failure: { (error:String) in
                print("load current position")
         
            })

    }
    
}






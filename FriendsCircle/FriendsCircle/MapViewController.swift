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
    @IBOutlet var NoSessionLabel: UILabel!
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
    var currentMoment = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMoment = NSDate()
        displayTime(currentMoment)
        
        currentSection = TrackingSection()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        NoSessionLabel.alpha = 0
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
    
    func displayTime(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let dateString = dateFormatter.stringFromDate(date)
        print("Testing date: \(dateString)")
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
                self.currentMoment = NSDate()
                self.currentTrackingSection = tracking
                //if (self.currentMoment >= currentTrackingSection.begin) || (self.currentMoment <= currentTrackingSection.begin) {
                let beginCompare = self.currentMoment.compare(self.currentTrackingSection.begin!)
                let endCompare = self.currentMoment.compare(self.currentTrackingSection.end!)
                if (beginCompare == NSComparisonResult.OrderedDescending) && (endCompare == NSComparisonResult.OrderedAscending){
                    
                    print("tracking happening")
                    self.NoSessionLabel.alpha = 0
                    print("Current Time:")
                    self.displayTime(self.currentMoment)
                    print("Begin and eng:")
                    self.displayTime(self.currentTrackingSection.begin!)
                    self.displayTime(self.currentTrackingSection.end!)
                    print("tracking begin at: \(self.currentTrackingSection.begin) and end at: \(self.currentTrackingSection.end)")
                    for user in self.currentTrackingSection.attendUser {
                        self.phoneNumber.append(user.phoneNumber!)
                    }
                    self.loginClient.getListUsersByNumbers(self.phoneNumber) { (users: [User]) in
                        self.attendedUser = users
                        if self.mapView?.annotations != nil { self.mapView.removeAnnotations(self.mapView.annotations as [MKAnnotation]) }
                        for us in users {
                            if us.phoneNumber != self.currentUser?.phoneNumber {
                                if us.longtitude != nil && us.latitude != nil {
    //                                let coor = CLLocationCoordinate2D(latitude: user.latitude!,longitude: user.longtitude!)
    //                                let time =  self.currentTrackingSection.timingCalculation(coor, destination: CLLocationCoordinate2D(latitude: 38.33233141, longitude: -122.0312186 ))
    //                                print("\(us.name) \(time)")
                                    self.createAnnotation(us)
                                }
                            }
                    }
                }
                } else if beginCompare == NSComparisonResult.OrderedAscending {
                    self.NoSessionLabel.text = "Session will happen soon"
                    self.NoSessionLabel.alpha = 1
                } else if endCompare == NSComparisonResult.OrderedDescending {
                    self.NoSessionLabel.text = "Session is expired"
                    self.NoSessionLabel.alpha = 1
                }
            }
            }, failure: { (error:String) in
                self.NoSessionLabel.alpha = 1
                print("load current position")
                
        })

    }
    
}






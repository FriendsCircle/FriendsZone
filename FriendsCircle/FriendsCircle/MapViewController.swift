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
    var currentTrackingSection = TrackingSection()
    var currentUser = User.currentUser
    var currentSection: TrackingSection?
    let loginClient = LoginClient()
    var locationManager : CLLocationManager!
    var phoneNumber = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
//        let workSaiGon = MKPointAnnotation()
//        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
//        addAnnotationAtCoordinate(workSaiGon.coordinate, name: "Work Saigon")
//        let workSaiGon2 = MKPointAnnotation()
//        workSaiGon2.coordinate = CLLocationCoordinate2DMake(10.8016132,106.6639988)
//        addAnnotationAtCoordinate(workSaiGon2.coordinate, name: "Work Saigon2")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        // get informaiton of current user: session id
        self.loginClient.getUserInfo((self.currentUser?.phoneNumber)!, success: { (user: User) in
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            //self.createAnnotation(user)
            self.currentUser = user
            print(user.sessionId)
            
            //get information of current session
            self.loginClient.getSessionByID((self.currentUser?.sessionId)!) { (tracking: TrackingSection) in
                
                self.currentTrackingSection = tracking
                
                
                
                for user in self.currentTrackingSection.attendUser {
                    self.phoneNumber.append(user.phoneNumber!)
                }
                self.loginClient.getListUsersByNumbers(self.phoneNumber) { (users: [User]) in
                    self.attendedUser = users
                }
                for user in self.attendedUser {
                    print("Attended User: \(user.name): \(user.phoneNumber)")
                }
                
//                for user in self.currentTrackingSection.attendUser {
//                    self.createAnnotation(user)
//                }
            }
        })
        
       
        

        
        
//        loginClient.getListUser { (users: [User]) in
//            self.attendedUser = users
//            for user in self.attendedUser {
//                print("Attended User: \(user.name): \(user.phoneNumber)")
//            }
//        }
        
        //        loginClient.getUserInSession({ (u : User) in
        //            print(u)
        //            if self.currentUser?.phoneNumber != u.phoneNumber {
        //                self.createAnnotation(u)
        //            }
        //
        //            }, sessionId: (self.currentUser?.sessionId)!)
        
        //        loginClient.getListUser { (dictionary: NSDictionary) in
        //
        //            
        //            print(dictionary)
        //        }

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
        let tempAnnotation: MKPointAnnotation!
        if user.longtitude != nil && user.latitude != nil {
            tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = CLLocationCoordinate2DMake(user.latitude!,user.longtitude!)
            let str = String(tempAnnotation.coordinate.longitude) +  "-" + String(tempAnnotation.coordinate.latitude)

            self.addAnnotationAtCoordinate(tempAnnotation.coordinate, name: user.name! + str)
            tempAnnotation.title = str
            print(user.name!)
            print(tempAnnotation.coordinate)
            
//            self.addAnnotationAtCoordinate(tempAnnotation.coordinate, name: user.name!)
            
            
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
            
            let userRef = loginClient.getRefFirebaseByPhoneNumber((currentUser!.phoneNumber)!)
            let longtitude = ["longtitude": location.coordinate.longitude]
            let latitude = ["latitude": location.coordinate.latitude]
            userRef.updateChildValues(latitude)
            userRef.updateChildValues(longtitude)
        }
    }
    
    
}






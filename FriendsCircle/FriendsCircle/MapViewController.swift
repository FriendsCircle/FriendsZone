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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        currentUser = User.currentUser
        loginClient.getUserLongLat((currentUser?.phoneNumber)!)

        //currentSection = getSection(currentUser.SectionID)
        
        
        let workSaiGon = MKPointAnnotation()
        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
        
        let initRegion = MKCoordinateRegionMakeWithDistance(workSaiGon.coordinate, regionRadius * 2.0 , regionRadius * 2.0)
        mapView.setRegion(initRegion, animated: false)
        
        
        testDataInit()

       for user in attendedUser {
            currentTrackingSection.addUser(user)
        }
        
        currentTrackingSection.destination = CLLocation(latitude: 10.7564032, longitude: 106.660236)
        
        let annotations = currentTrackingSection.locatingAllMember()
        
        let destination = MKPointAnnotation()
        destination.coordinate = (currentTrackingSection.destination?.coordinate)!
        mapView.addAnnotation(destination)
        mapView.addAnnotations(annotations)
    }
    
    
    
    
    //MARK: Testing data
    func testDataInit(){
        
        var user = User(phoneNumber: "0937264497")
        user.firstName = "Vu"
        user.lastName = "Nguyen"
        user.coordinate = CLLocation(latitude: 10.7761477,longitude: 106.6640438)
        attendedUser.append(user)
      
        
        
        user = User(phoneNumber: "01689903461")
        user.firstName = "Gon"
        user.lastName = "Nguyen"
        user.coordinate = CLLocation(latitude: 10.772736, longitude: 106.658706)
        //user.coordinate?.coordinate = CLLocationCoordinate2D(latitude: 10.772736,longitude: 106.658706)
        attendedUser.append(user)
        print("\(attendedUser.count)")
    }


    @IBAction func logoutTapped(sender: AnyObject) {
        loginClient.logout()
    }


}

extension MapViewController: MKMapViewDelegate {
    
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
    
}






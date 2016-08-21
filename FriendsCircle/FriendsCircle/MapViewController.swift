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
        /*
        let workSaiGon = MKPointAnnotation()
        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
        
        mapView.addAnnotation(workSaiGon)
        let initRegion = MKCoordinateRegionMakeWithDistance(workSaiGon.coordinate, self.regionRadius * 1.0 , self.regionRadius * 1.0)
        self.mapView.setRegion(initRegion, animated: false)
        
        let user = User.currentUser
        //loginClient.getUserInfo(user!.phoneNumber! as String)
        loginClient.getUserInfo({ (user: User) in
            print(user)
            self.currentTrackingSection.addUser(user)
            
            let annotation = MKPointAnnotation()
//            annotation.coordinate.longitude = user.longtitude!
//            annotation.coordinate.latitude = user.latitude!
            
            print(annotation.coordinate)
            self.mapView.addAnnotation(annotation)
           
        }, phone: user!.phoneNumber!)


        //currentUser = User.currentUser
        //loginClient.getUserLongLat((currentUser?.phoneNumber)! as String)

        //getUserInfor(currentUser.phoneNum)
        //currentSection = getSection(currentUser.SectionID)

        //testDataInit()

//       for user in attendedUser {
//            currentTrackingSection.addUser(user)
//        }
//        
//        currentTrackingSection.destination = CLLocation(latitude: 10.7564032, longitude: 106.660236)
        
        

        //print("All member:\(annotations)")
        
        //mapView.addAnnotations(annotations)
        
        
       // let userAnoo = UserAnnotation(user: currentUser!)
        

        let annotations = currentTrackingSection.locatingAllMember()
        let destination = MKPointAnnotation()
        destination.coordinate = CLLocationCoordinate2D(latitude: 10.7564032, longitude: 106.660236)
       
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
 */
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






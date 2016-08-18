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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        let workSaiGon = MKPointAnnotation()
        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
        
        let initRegion = MKCoordinateRegionMakeWithDistance(workSaiGon.coordinate, regionRadius * 2.0 , regionRadius * 2.0)
        mapView.setRegion(initRegion, animated: false)
        
        
        testDataInit()

       for user in attendedUser {
            currentTrackingSection.addUser(user)
        }
        
        currentTrackingSection.destination = CLLocation(latitude: 10.7564032, longitude: 106.660236)
        
        //let annotations = currentTrackingSection.locatingAllMember()
        //print("All member:\(annotations)")
        
        //mapView.addAnnotations(annotations)
        
        let destination = MKPointAnnotation()
        destination.coordinate = CLLocationCoordinate2D(latitude: 10.7564032, longitude: 106.660236)
       // let userAnoo = UserAnnotation(user: currentUser!)
        mapView.addAnnotation(destination)
        //mapView.addAnnotation(userAnoo)
        //mapView.addAnnotations(annotations)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
    
    
    
    func currentUserInit() {
        
        //currentUser?.Avatar? = UIImage(named: "avatar")!
        //currentUser?.firstName = "Vu"
        currentUser?.name = "Vu Nguyen"
        currentUser?.phoneNumber = "0937264497"
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






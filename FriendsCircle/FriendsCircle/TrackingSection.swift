//
//  TrackingSection.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class TrackingSection: NSObject {
    var attendUser = [User]()
    var attendUsedAnnotations = [UserAnnotation]()
    var begin: NSDate?
    var end: NSDate?
    var destination: CLLocation?
    var trackingSectionID: String?
    
    let loginClient = LoginClient()
    
    override init() {
        super.init()
    }
    func addUser(user: User)
    {
        attendUser.append(user)
    }
    
    func locatingAllMember() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        var annotation = MKPointAnnotation()
        //var isChanged = false
        for user in attendUser {
            annotation = MKPointAnnotation()
            annotation.coordinate.longitude = user.longtitude!
            annotation.coordinate.longitude = user.latitude!
            annotation.title = user.name ?? "no name"
            //print("\(user.coordinate!.coordinate)")
            annotations.append(annotation)
            
            let userLocation = CLLocation(latitude: (user.latitude)!, longitude: (user.longtitude)!)
            
           
            if self.destination != nil {
                
                print("\(destination?.distanceFromLocation(userLocation))")
                //timingCalculation(user.coordinate!.coordinate, destination: (self.destination?.coordinate)! )
            }
        }
        
        return annotations
    }
    
    func timingCalculation(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> String  {
        let timeString: String!
        let sourceMark = MKPlacemark(coordinate: source, addressDictionary: nil)
        let destinationMark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        let request:MKDirectionsRequest = MKDirectionsRequest()
        var route: MKRoute?
        // source and destination are the relevant MKMapItems
        request.source = MKMapItem(placemark: sourceMark)
        request.destination = MKMapItem(placemark: destinationMark)
        
        
        // Specify the transportation type
        request.transportType = MKDirectionsTransportType.Automobile
        
        // If you're open to getting more than one route,
        // requestsAlternateRoutes = true; else requestsAlternateRoutes = false;
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            
            if error == nil {
                let time: String?
//                time = response
                // Get whichever currentRoute you'd like, ex. 0
                route = response!.routes[0] as MKRoute
                print("time: \(route?.expectedTravelTime)")
                
            }
        })
        timeString = "\(route?.expectedTravelTime)"
        
        return timeString
    }
    
    
    //MARK: Function to communicate with database
    
    func submitSection() {
        
        let sessionId = Int(arc4random_uniform(UInt32(100000)))
        trackingSectionID = "\(sessionId)"
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let beginString = dateFormatter.stringFromDate(begin!)
        let endString = dateFormatter.stringFromDate(end!)
        var phoneNums = [String]()
        for user in attendUser {
            phoneNums.append(user.phoneNumber!)
        }
        
        
        let destinationDictionary = NSDictionary(dictionary: ["longtitue": "\((destination?.coordinate.longitude)!)", "latitude": "\((destination?.coordinate.latitude)!)"])
        print("Submit destination \(destinationDictionary)")
        let sessionTracking = ["sessionId": ("\(sessionId)"), "destination" : destinationDictionary, "users": phoneNums, "beginTime" : beginString, "endTime": endString]
        
        
        loginClient.createSessionTracking("\(sessionId)", sessionTracking: sessionTracking)
    }
    
    
    
    func createLocalNotification() {
        let theDate  = NSDate()
        let dateComp = NSDateComponents()
        dateComp.second  = 15
        let calendar = NSCalendar.currentCalendar()
        let fireDate: NSDate = calendar.dateByAddingComponents(dateComp, toDate: theDate, options: NSCalendarOptions.init(rawValue: 0))!
        
        let notification = UILocalNotification()
        notification.alertBody = "This notification from Friend Circle"
        
        notification.fireDate = fireDate
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }

    

}

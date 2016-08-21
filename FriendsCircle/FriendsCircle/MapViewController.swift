//
//  MapViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import MapKit
import ContactsUI
import Contacts

class MapViewController: UIViewController {
    
    //outlet
    @IBOutlet var mapView: MKMapView!
    
    
    var contactStore = CNContactStore()
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
        
        let workSaiGon = MKPointAnnotation()
        workSaiGon.coordinate = CLLocationCoordinate2DMake(10.7803616,106.6860085)
        
        mapView.addAnnotation(workSaiGon)
        let initRegion = MKCoordinateRegionMakeWithDistance(workSaiGon.coordinate, self.regionRadius * 1.0 , self.regionRadius * 1.0)
        self.mapView.setRegion(initRegion, animated: false)
        
        let user = User.currentUser
        //loginClient.getUserInfo(user!.phoneNumber! as String)
        loginClient.getUserInfo({ (user: User) in
            self.currentTrackingSection.addUser(user)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.longitude = user.longtitude!
            annotation.coordinate.latitude = user.latitude!
            
            print(annotation.coordinate)
            self.mapView.addAnnotation(annotation)
           
        }, phone: user!.phoneNumber as! String)

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
        
        
    }
    
    //MARK: additional functions
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "FriendsCircle", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        //let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        //let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        let presentedViewController = self
        
        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    func fetchContact() -> Bool {
        requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                //let predicate = CNContact.predicateForContactsMatchingName(self.txtLastName.text!)
                let predicate = NSPredicate(value: true) // fetch all contact list without predicating string
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                var contacts = [CNContact]()
                var message: String!
                
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                fetchRequest.mutableObjects = false
                fetchRequest.unifyResults = true
                fetchRequest.sortOrder = .UserDefault
                
                
                let contactsStore = self.contactStore
                
                do {
                    //contacts = try contactsStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
                    
                    
                    try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                        //do something with contact
                        if contact.phoneNumbers.count > 0 {
                            contacts.append(contact)
                        }
                    }
                    
                    if contacts.count == 0 {
                        message = "No contacts were found matching the given name."
                    }
                }
                catch {
                    message = "Unable to fetch contacts."
                }
                
                
                if message != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showMessage(message)
                    })
                }
                else {
                    
                    for contact in contacts {
                        
                        
                        print("\(contact.familyName), \(contact.givenName),\(contact.phoneNumbers)")
                        print("\(contact.phoneNumbers)")
                        for num in contact.phoneNumbers {
                            let numVal = num.value as! CNPhoneNumber
                            if num.label == CNLabelPhoneNumberMobile {
                                //mobiles.append(numVal)
                                print("\(numVal.stringValue)")
                            }
                        }
                    }
                }
            }
        }
        
        return true
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






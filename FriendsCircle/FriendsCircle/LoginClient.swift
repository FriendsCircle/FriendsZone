//
//  File.swift
//  LoginDemo
//
//  Created by Le Huynh Anh Tien on 8/15/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import MapKit

class LoginClient {
    
    var loginSuccess: (() -> ())?
    var loginFailure : ((String) -> ())?
    var ref: FIRDatabaseReference!
    let whitespace = NSCharacterSet.whitespaceCharacterSet()
    init() {
        configureDatabase()
        
    }
    func getVerifyPhoneNumber(success: () -> (), failure: (String) -> (), phone: String, name: String) {
        // add link to server heroku for get verify number 
        // https://whispering-stream-37719.herokuapp.com/test
        Alamofire.request(.GET, "https://whispering-stream-37719.herokuapp.com/test", parameters: ["phone": phone]) .responseJSON { response in
            if ((response.response) != nil) {
                if let res: NSHTTPURLResponse = response.response! {
                    if (res.statusCode == 200) {
                        let data: NSDictionary = response.result.value! as! NSDictionary
                        if (data["success"] as! Bool == true) {
                            let users = self.ref.child("users")
                            let verifyNumber =  data["verifyNum"] as! String
                            let userDic = ["name" : name ,"phoneNumber": phone, "verifyNumber": verifyNumber, "active": false, "longtitude": "", "latitude": "", "sessionId": ""]
                            users.updateChildValues([phone: userDic])
                            print("Success")
                            success()
                            
                        } else {
                            failure("Phone number is inconrrect")
                        }
                    }
                }
            } else {
                failure("Can't connect server")
            }
            
        }
        
    }
    
    func login(success: () -> (), failure: (String) -> (), phone: String, verifyNumber: String) {
        let userRef = getRefFirebaseByPhoneNumber(phone)
        
        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            // do some stuff once
            let data: NSDictionary = snapshot.value! as! NSDictionary
            if (data["verifyNumber"] as! String == verifyNumber) {
                // create new user save to current user
                let user = User(dictionary: data)
                User.currentUser = user
                print("Logged In")
                success()
            } else {
                failure("Verify fail")
            }
        })
        
    }
    
    func getRefFirebaseByPhoneNumber(phone: String) -> FIRDatabaseReference {
        let usersRef = self.ref.child("users")
        return usersRef.child(phone)
    }
    
    func getListUser(success: ([User]) -> ()) {
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let data: NSDictionary = snapshot.value as! NSDictionary
            var users = [User]()
            for keyString in data.allKeys {
                let userDictionary = data["\(keyString)"] as! NSDictionary
                let user = User(phoneNumber : userDictionary["phoneNumber"] as! String)
                user.name = userDictionary["name"] as! String
                users.append(user)
            }
//            for user in users {
//                print("\(user.phoneNumber), \(user.name) ")
//            }
            print(data.allKeys)
            success(users)
            
        })
    }
    
    func getListUsersByNumbers(phoneNumbers: [String], success: ([User]) -> ()) {
        ref.child("users").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let data: NSDictionary = snapshot.value as! NSDictionary
            var users = [User]()
            for number in phoneNumbers {
                let userDictionary = data[number] as! NSDictionary
                let user = User(dictionary: userDictionary)
                //let user = User(phoneNumber : userDictionary["phoneNumber"] as! String)
                user.name = userDictionary["name"] as! String
                users.append(user)
            }
            //            for user in users {
            //                print("\(user.phoneNumber), \(user.name) ")
            //            }
            print(data.allKeys)
            success(users)
            
        })
    }


    func getRefFirebaseSessionTracking(sessionId: String) -> FIRDatabaseReference {
        let sessionRef = self.ref.child("session")
        return sessionRef.child(sessionId)
        
    }
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    func getRefDatabase() -> FIRDatabaseReference {
        return self.ref
    }
    
    func createSessionTracking(sessionId: String, sessionTracking: NSDictionary) {
        let sessionref = self.ref.child("session")
        sessionref.updateChildValues([sessionId: sessionTracking])
        getSession(sessionId)
    }
    
    func getSession(sessionId: String) {
        let sessionRef = getRefFirebaseSessionTracking(sessionId)
        let handle = sessionRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("null")
            } else {
                let data = snapshot.value! as! NSDictionary
                // callback
                self.getListPhoneNumberOfSession(data)
            }
            
        }, withCancelBlock: { error in
                print(error.description)
        })
        ref.removeObserverWithHandle(handle)
    }
    
    // callback get list phone number of session
    func getListPhoneNumberOfSession(data: NSDictionary){
        let listUserPhone = data["users"] as! NSArray
        for userPhone in listUserPhone {
            
            let userRef = getRefFirebaseByPhoneNumber(userPhone as! String)
            let session = ["sessionId": data["sessionId"] as! String]
            userRef.updateChildValues(session)
        }
    }
    func getSessionByID(sessionID: String, success:(TrackingSection) -> ()) {
        let sessionRef = getRefFirebaseSessionTracking(sessionID)
        sessionRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("null")
            } else {
                
                let data = snapshot.value! as! NSDictionary
                let trackingSession = TrackingSection()
                //get time of tracking session
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                trackingSession.begin = dateFormatter.dateFromString(data["beginTime"] as! String)
                trackingSession.end = dateFormatter.dateFromString(data["endTime"] as! String)
                //get session ID
                trackingSession.trackingSectionID = data["sessionId"] as! String
                //get session destination
                let latString = data.valueForKeyPath("destination.latitude") as! NSString
                let longString = data.valueForKeyPath("destination.longtitue") as! NSString
                trackingSession.destination = CLLocation(latitude: latString.doubleValue, longitude: longString.doubleValue)
                //get session Users
                var users = [User]()
                let phoneNumbers = data["users"] as! [String]
                for phoneNumber in phoneNumbers {
                    let user = User(phoneNumber: phoneNumber)
                    users.append(user)
                }
                
                trackingSession.attendUser = users
                
                success(trackingSession)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })

    }
    
    
    func getUserInSession(success:(User) -> (), sessionId: String){
        let sessionRef = getRefFirebaseSessionTracking(sessionId)
        sessionRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("null")
            } else {
                let data = snapshot.value! as! NSDictionary
                print("Check data of users in session: \(data)")
                self.getUsersLongLatInSession(data, success: { (user: User) in
                    success(user)
                })
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }

    func getUsersLongLatInSession(data: NSDictionary, success: (User) -> ()) {
        let listUserPhone = data["users"] as! NSArray
        for userPhone in listUserPhone {
            let userRef = getRefFirebaseByPhoneNumber(userPhone as! String)
            userRef.observeEventType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    print("null")
                } else {
                    let data = snapshot.value! as! NSDictionary
                    // callback
                    let tempUser = User(dictionary: data)
                    success(tempUser)
                    
                }
            }, withCancelBlock: { error in
                print(error.description)
            })
            
        }
    }
    
    
    func getUserInfo(phone: String, success: (User) ->  ()) {
        let userRef = getRefFirebaseByPhoneNumber(phone)
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("null")
            } else {
                let data = snapshot.value! as! NSDictionary
                let sessionId = data["sessionId"] as! String
                if sessionId.stringByTrimmingCharactersInSet(self.whitespace) != "" {
                    let userTeamp = User(dictionary: data)
                    //userTeamp.sessionId = sessionId
                    success(userTeamp)
                } else {
                    print("error no session id")
                }
            }
        })
    }

    func logout() {
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName(User.logoutString, object: nil)
    }
    
}

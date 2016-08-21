//
//  User.swift
//  LoginDemo
//
//  Created by Le Huynh Anh Tien on 8/15/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import MapKit

class User: NSObject {
    var name: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: NSString?
    var verifyNumber: NSString?
    var active: Bool?
    var dictionary: NSDictionary?
    var coordinate: CLLocation?
    var sessionId: String?
    var longtitude: String?
    var latitude: String?
    let loginClient = LoginClient()
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        verifyNumber = dictionary["verifyNumber"] as? String
        active = dictionary["active"] as? Bool
        coordinate = dictionary["coordinate"] as? CLLocation
        sessionId = dictionary["sessionId"] as? String
        longtitude = dictionary["longtitude"] as? String
        latitude = dictionary["latitude"] as? String

        super.init()
    }
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    static let logoutString = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if  let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                    
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    
}



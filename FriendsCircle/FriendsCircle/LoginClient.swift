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

class LoginClient {
    
    var loginSuccess: (() -> ())?
    var loginFailure : ((String) -> ())?
    var ref: FIRDatabaseReference!
    
    init() {
        configureDatabase()
        
    }
    func getVerifyPhoneNumber(success: () -> (), failure: (String) -> (), phone: String) {
        
        Alamofire.request(.GET, "http://localhost:3000/test", parameters: ["phone": phone]) .responseJSON { response in
            if ((response.response) != nil) {
                if let res: NSHTTPURLResponse = response.response! {
                    if (res.statusCode == 200) {
                        let data: NSDictionary = response.result.value! as! NSDictionary
                        if (data["success"] as! Bool == true) {
                            let users = self.ref.child("users")
                            let verifyNumber =  data["verifyNum"] as! String
                            let userDic = ["phoneNumber": phone, "verifyNumber": verifyNumber, "active": false]
                            users.setValue([phone: userDic])
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
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    func logout() {
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName(User.logoutString, object: nil)
    }
    
}

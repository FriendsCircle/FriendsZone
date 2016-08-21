//
//  LoginViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class LoginViewController: UIViewController {
    
    @IBOutlet var phoneNumTxtField: UITextField!
    var users: [User]?
    var verifyNum: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumTxtField.text = "+84937264497"

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogin(sender: UIButton) {
        
        if let phone = phoneNumTxtField.text {
            getVerifyPhoneNumber(phone)
        }
        
        performSegueWithIdentifier("verifySegue", sender: self)
    }
    

    
    func getVerifyPhoneNumber(phone:String) {
        
        let loginClient = LoginClient()
        //        let userRef = loginClient.getRefFirebaseByPhoneNumber(phone)
        loginClient.getVerifyPhoneNumber({ () -> () in
            print("I get verify in")
            //self.performSegueWithIdentifier("verifySegue", sender: nil)
            }, failure: { (error) in
                print(error)
            }, phone: phone)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Login2ContactsList" {
            let nextVC = segue.destinationViewController as! ContactsListViewController
            
        }
        if segue.identifier == "verifySegue" {
            let verifyVC = segue.destinationViewController as! VerifyViewController
            verifyVC.phoneNum = phoneNumTxtField.text!
            
        }
        
        // Pass the selected object to the new view controller.
    }
    

}

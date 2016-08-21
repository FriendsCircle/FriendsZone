//
//  LoginViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//  TODO: Check login logic
//  keyboard height : 216pts


import UIKit
import Contacts
import ContactsUI


class LoginViewController: UIViewController {
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet var phoneNumTxtField: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
    var users: [User]?
    var verifyNum: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLogin(sender: UIButton) {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        if(phoneNumTxtField.text!.stringByTrimmingCharactersInSet(whitespace) == ""){
            infoLbl.text = "Please enter your \n phone number"
            return
        } else if (nameLabel.text!.stringByTrimmingCharactersInSet(whitespace) == "") {
            infoLbl.text = "Please enter your name number"
            return
        } else {
            let rawPhoneNum = "+84\(phoneNumTxtField.text!)"
            print(rawPhoneNum)
            let alertController = UIAlertController(title: "We are sending you an SMS containing a code to verify the phone number: \(rawPhoneNum)", message:
                nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alertController, animated: true, completion: nil)
            getVerifyPhoneNumber(rawPhoneNum)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            { action -> Void in
                self.performSegueWithIdentifier("verifySegue", sender: self)
            })
        }
    }
    
    func getVerifyPhoneNumber(phone:String) {
        let loginClient = LoginClient()
        
        loginClient.getVerifyPhoneNumber({ () -> () in
            print("I get verify in")
        }, failure: { (error) in
                print(error)
        }, phone: phone, name: nameLabel.text!)
        
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let verifyVC = segue.destinationViewController as! VerifyViewController
        verifyVC.phoneNum = "+84\(phoneNumTxtField.text!)"
    }
}

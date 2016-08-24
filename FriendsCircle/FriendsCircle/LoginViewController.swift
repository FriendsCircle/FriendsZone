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
    var rawPhoneNum: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
//        backgroundImage.image = UIImage(named: "Background")
//        backgroundImage.alpha = 0.8
//        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
//        
//        self.view.insertSubview(backgroundImage, atIndex: 0)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    

    @IBAction func onLogin(sender: UIButton) {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        if(phoneNumTxtField.text!.stringByTrimmingCharactersInSet(whitespace) == ""){
            //infoLbl.text = "Please enter your \n phone number"
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.redColor().CGColor
            border.frame = CGRect(x: 0, y: phoneNumTxtField.frame.size.height - width, width:  phoneNumTxtField.frame.size.width, height: phoneNumTxtField.frame.size.height)
            
            border.borderWidth = width
            phoneNumTxtField.layer.addSublayer(border)
            phoneNumTxtField.layer.masksToBounds = true
            return
        } else if (nameLabel.text!.stringByTrimmingCharactersInSet(whitespace) == "") {
            //infoLbl.text = "Please enter your name"
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.redColor().CGColor
            border.frame = CGRect(x: 0, y: nameLabel.frame.size.height - width, width:  nameLabel.frame.size.width, height: nameLabel.frame.size.height)
            
            border.borderWidth = width
            nameLabel.layer.addSublayer(border)
            nameLabel.layer.masksToBounds = true
            return
        } else {
            
            let phoneNumString = "\(phoneNumTxtField.text!)"
            if phoneNumString.containsString("+84") {
                rawPhoneNum = phoneNumString
            } else if phoneNumString.substringToIndex(phoneNumString.startIndex.successor()) == "0" {
                rawPhoneNum = "+84\(phoneNumString.substringFromIndex(phoneNumString.startIndex.successor()))"
            } else { rawPhoneNum = "+84\(phoneNumString)" }
            
            
            let alertController = UIAlertController(title: "We are sending you an SMS containing a code to verify the phone number: \(rawPhoneNum!)", message:
                nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alertController, animated: true, completion: nil)
            getVerifyPhoneNumber(rawPhoneNum!)
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
        verifyVC.phoneNum = rawPhoneNum!
        
    }
}

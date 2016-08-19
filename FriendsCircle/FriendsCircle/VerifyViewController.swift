//
//  VerifyViewController.swift
//  FriendsCircle
//
//  Created by Le Huynh Anh Tien on 8/17/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    @IBOutlet weak var verifyTextField: UITextField!
    var phoneNum: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    @IBAction func VerifyTapped(sender: AnyObject) {
        let loginClient = LoginClient()
        if let verifyText = verifyTextField.text {
            loginClient.login({
                let userRef = loginClient.getRefFirebaseByPhoneNumber(self.phoneNum)
                let active = ["active": true]
                userRef.updateChildValues(active)
                print("Login Success -> performsegue with home screen")
                self.performSegueWithIdentifier("homeSegue", sender: nil)
                }, failure: { (error: String) in
                    print(error)
                }, phone: phoneNum, verifyNumber: verifyText)
        } else {
            print("Error Verify")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

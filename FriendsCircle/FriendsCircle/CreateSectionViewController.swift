//
//  CreateSectionViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/17/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit

class CreateSectionViewController: UIViewController {

    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var fromTimeTextField: UITextField!
    @IBOutlet var toTimeTextField: UITextField!
    
    let loginClient = LoginClient()
       override func viewDidLoad() {
        super.viewDidLoad()
        
        loginClient.getUserLongLat("+841696359605")
    }

    @IBAction func onTextFieldEditting(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        if sender.tag == 1 {
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        } else if (sender.tag == 2) || (sender.tag == 3) {
            datePickerView.datePickerMode = UIDatePickerMode.Time
        }
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    @IBAction func createSession(sender: AnyObject) {
        let sessionId = Int(arc4random_uniform(UInt32(100000)))
        let destination = NSDictionary(dictionary: ["longtitue": "103.444", "latitude": "37.333"])
        let sessionTracking = ["sessionId": ("\(sessionId)"), "destination" : destination, "users": ["+841696359605", "+84905860687" , "+84937264497"], "beginTime" : "", "endTime": ""]
        loginClient.createSessionTracking("\(sessionId)", sessionTracking: sessionTracking)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        if sender.datePickerMode == .Date {
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateTextField.text = dateFormatter.stringFromDate(sender.date)
        } else if sender.datePickerMode == .Time {
            fromTimeTextField.text = dateFormatter.stringFromDate(sender.date)
        }
    }
}
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

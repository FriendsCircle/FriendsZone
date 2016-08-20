//
//  DateTimeCell.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/20/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit

protocol DateTimeCellDelegate {
    func fromTime(dateTimeCell: DateTimeCell, didFinishedInput fromTime: NSDate)
    func toTime(dateTimeCell: DateTimeCell, didFinishedInput toTime: NSDate)
    
}

class DateTimeCell: UITableViewCell {
    
    
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    
    var fromTime: NSDate?
    var toTime: NSDate?
    var delegate: DateTimeCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onTextFieldEditting(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        
        if sender.tag == 0 {
        datePickerView.addTarget(self, action: #selector(self.fromPickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        } else if sender.tag == 1 {
        datePickerView.addTarget(self, action: #selector(self.toPickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }
        
    }

    func fromPickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
    
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        fromTextField.text = dateFormatter.stringFromDate(sender.date)
        fromTime = sender.date
        print(dateFormatter.stringFromDate(sender.date))
        delegate?.fromTime(self, didFinishedInput: fromTime!)
        
    }
    func toPickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        toTextField.text = dateFormatter.stringFromDate(sender.date)
        self.toTime = sender.date
        print(dateFormatter.stringFromDate(sender.date))
        delegate?.toTime(self, didFinishedInput: toTime!)
    }

}

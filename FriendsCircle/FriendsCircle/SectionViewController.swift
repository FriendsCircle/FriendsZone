//
//  SectionViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/20/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class SectionViewController: UIViewController {
    
    let loginClient = LoginClient()
    var trackingSection = TrackingSection()
    var selectedContacts = [CNContact]()
    var users = [User]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loginClient.getUserLongLat("+841696359605")
    }
    

    @IBAction func onBackPressed(sender: UIBarButtonItem) {
//        dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onSubmitPressed(sender: UIBarButtonItem) {
                
        trackingSection.submitSection()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Section2ContactsList" {
            let contactsVC = segue.destinationViewController as! ContactsListViewController
            contactsVC.delegate = self
        }
    }
  
}

extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return selectedContacts.count + 1}
        else { return 1 }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 50, height: 15))
        //label.font =  UIFont.fontWithSize(17.0)
        //label.font = UIFont.boldSystemFontOfSize(15.0)
        
        if section == 0  { label.text = "Time of Section"}
        else if section == 1  { label.text = "Destination"}
        else if section == 2  { label.text = "Members"}
        
        label.textColor = UIColor.darkGrayColor()
        label.sizeToFit()
        view.addSubview(label)
        
        label.textAlignment = NSTextAlignment.Center
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)

        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell =  tableView.dequeueReusableCellWithIdentifier("DateTimeCell") as! DateTimeCell
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let DestCell = tableView.dequeueReusableCellWithIdentifier("DestinationCell") as! DestinationCell
            return DestCell
        } else {
            if indexPath.row == 0 {
            let addButtonCell = tableView.dequeueReusableCellWithIdentifier("AddFriendsButtonCell") as! AddFriendsButtonCell
            return addButtonCell
            } else {
                let friendCell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendCell
                friendCell.nameLabel.text = selectedContacts[indexPath.row - 1].givenName
                for num in selectedContacts[indexPath.row - 1].phoneNumbers {
                    let numVal = num.value as! CNPhoneNumber
                    if num.label == CNLabelPhoneNumberMobile {
                        friendCell.phoneNumLabel.text = ("\(numVal.stringValue)")
                        friendCell.userInteractionEnabled = false
                        
                    }
                    
                }
                //friendCell.nameLabel = selectedContacts[indexPath.row -1]
                return friendCell
            }
        }
    }
}
extension SectionViewController: ContactsListViewControllerDelegate {
    func contactsListViewController(contactsListViewController: ContactsListViewController, didSelectedUsersList contacts: [CNContact]) {
        print("delegate success")
        for contact in contacts {
            let phoneNum: String?
            for num in contact.phoneNumbers {
                let numVal = num.value as! CNPhoneNumber
                if num.label == CNLabelPhoneNumberMobile {
                    phoneNum = "\(numVal.stringValue)"
                }
            let user = User(phoneNumber: phoneNum!)
                users.append(user)
        }
        self.selectedContacts = contacts
        tableView.reloadData()
        print("\(self.selectedContacts)")
    }
}


extension SectionViewController: DateTimeCellDelegate {
    func fromTime(dateTimeCell: DateTimeCell, didFinishedInput fromTime: NSDate) {
        trackingSection.begin = fromTime
        print("\(fromTime)")
    }
    
    func toTime(dateTimeCell: DateTimeCell, didFinishedInput toTime: NSDate) {
        trackingSection.end = toTime
        print("\(toTime)")
    }
        
}
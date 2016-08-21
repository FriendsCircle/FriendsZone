//
//  ContactsListViewController.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var users: [User]?
    var contactStore = CNContactStore()
    var contacts = [CNContact]()
    var selectedContacts = [CNContact]()
    var unselectedContacts = [CNContact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchContact()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func showMessage(message: String) {
        let alertController = UIAlertController(title: "FriendsCircle", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        //let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        //let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        let presentedViewController = self
        
        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    func fetchContact() -> Bool {
        requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                //let predicate = CNContact.predicateForContactsMatchingName(self.txtLastName.text!)
                let predicate = NSPredicate(value: true) // fetch all contact list without predicating string
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                
                var message: String!
                
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                fetchRequest.mutableObjects = false
                fetchRequest.unifyResults = true
                fetchRequest.sortOrder = .UserDefault
                
                
                let contactsStore = self.contactStore
                
                do {
                    //contacts = try contactsStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
                    
                    
                    try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                        //do something with contact
                        if contact.phoneNumbers.count > 0 {
                            self.contacts.append(contact)
                        }
                    }
                    
                    if self.contacts.count == 0 {
                        message = "No contacts were found matching the given name."
                    }
                }
                catch {
                    message = "Unable to fetch contacts."
                }
                
                
                if message != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showMessage(message)
                    })
                }
                else {
                    self.unselectedContacts = self.contacts
                    
                    for contact in self.contacts {
                        
                        
                        print("\(contact.familyName), \(contact.givenName),\(contact.phoneNumbers)")
                        print("\(contact.phoneNumbers)")
                        for num in contact.phoneNumbers {
                            let numVal = num.value as! CNPhoneNumber
                            if num.label == CNLabelPhoneNumberMobile {
                                //mobiles.append(numVal)
                                print("\(numVal.stringValue)")
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }


    @IBAction func dismissView(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

}

extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return unselectedContacts.count
        } else {
            return selectedContacts.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsCell") as! ContactsCell
        if indexPath.section == 0 {
            cell.nameLabel.text = unselectedContacts[indexPath.row].givenName
            for num in unselectedContacts[indexPath.row].phoneNumbers {
                let numVal = num.value as! CNPhoneNumber
                if num.label == CNLabelPhoneNumberMobile {

                    cell.phoneNumLabel.text = ("\(numVal.stringValue)")
                }
            }
            
        } else if indexPath.section == 1 {
            cell.nameLabel.text = selectedContacts[indexPath.row].givenName
            for num in selectedContacts[indexPath.row].phoneNumbers {
                let numVal = num.value as! CNPhoneNumber
                if num.label == CNLabelPhoneNumberMobile {
                    cell.phoneNumLabel.text = ("\(numVal.stringValue)")
                }
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 50, height: 15))
        if section == 0  { label.text = "Available friends"}
        else if section == 1  { label.text = "Selected friends"}
        
        
        label.textColor = UIColor.darkGrayColor()
        label.sizeToFit()
        view.addSubview(label)
        
        label.textAlignment = NSTextAlignment.Center
        view.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(view)

        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let ip = indexPath.row
            selectedContacts.append(unselectedContacts[ip])
            unselectedContacts.removeAtIndex(ip)
        } else if indexPath.section == 1 {
            let ip = indexPath.row
            unselectedContacts.append(selectedContacts[ip])
            selectedContacts.removeAtIndex(ip)
        }
        tableView.reloadData()
    }

}

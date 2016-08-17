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
    
    var users: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogin(sender: UIButton) {
        
        
        performSegueWithIdentifier("Login2Home", sender: self)
    }
    
    @IBAction func onFetchButton(sender: UIButton) {
        fetchContact()
        performSegueWithIdentifier("Login2ContactsList", sender: self)
    }
    
    //This function gets all the contact from iPhone. Currently, it gets first name, last name and phonenumber. With phonenumber, it gets phone in field CNLabelPhoneNumberMobile, it needs to be more investigated to get true mobilephone number
    
    func fetchContact() -> Bool {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                //let predicate = CNContact.predicateForContactsMatchingName(self.txtLastName.text!)
                let predicate = NSPredicate(value: true) // fetch all contact list without predicating string
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                var contacts = [CNContact]()
                var message: String!
                
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                fetchRequest.mutableObjects = false
                fetchRequest.unifyResults = true
                fetchRequest.sortOrder = .UserDefault
                
                
                let contactsStore = AppDelegate.getAppDelegate().contactStore
                
                do {
                    //contacts = try contactsStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
                    
                    
                    try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                        //do something with contact
                        if contact.phoneNumbers.count > 0 {
                            contacts.append(contact)
                        }
                    }
                    
                    if contacts.count == 0 {
                        message = "No contacts were found matching the given name."
                    }
                }
                catch {
                    message = "Unable to fetch contacts."
                }
                
                
                if message != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        AppDelegate.getAppDelegate().showMessage(message)
                    })
                }
                else {
                    
                    for contact in contacts {
                        
                        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Login2ContactsList" {
            let nextVC = segue.destinationViewController as! ContactsListViewController
            
        }
        // Pass the selected object to the new view controller.
    }
    

}

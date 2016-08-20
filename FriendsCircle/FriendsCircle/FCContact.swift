//
//  FCContact.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/20/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import Foundation


class FCContact: NSObject {
    var Name: String!
    var firstName: String?
    var lastName: String?
    var phoneNumber: String!
    
    init(name: String, mobilePhone: String) {
        self.Name = name
        self.phoneNumber = mobilePhone
    }
    
}
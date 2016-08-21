//
//  SessionTracking.swift
//  FriendsCircle
//
//  Created by Le Huynh Anh Tien on 8/19/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import MapKit

class SessionTracking: NSObject {
    var sessionID: NSString?
    var destination: CLLocation?
    var beginTime: NSDate?
    var endTime: NSDate?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        sessionID = dictionary["sessionID"] as? String
        destination = dictionary["destination"] as? CLLocation
        beginTime = dictionary["beginTime"] as? NSDate
        endTime = dictionary["endTime"] as? NSDate
        super.init()
    }
 
}

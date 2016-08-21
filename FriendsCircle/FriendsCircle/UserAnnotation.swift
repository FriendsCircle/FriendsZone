//
//  UserAnnotation.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage?
    var timeleft: String?
    var user: User!
    
    
    var title: String? {
        return user.name
    }
    
    var key: String {
        return user.phoneNumber!
    }
    
    func updateLocation(location: CLLocationCoordinate2D) {
        coordinate = location
    }
    var thumbnail: UIImage? {
        if let photo = photo {
            let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
            resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
            resizeRenderImageView.layer.borderWidth = 3.0
            resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
            resizeRenderImageView.image = photo
            
            UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
            resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return thumbnail
        }
        return nil
    }
    
    init(user: User) {
        self.user = user
        self.coordinate = (user.coordinate?.coordinate)!
    }
}
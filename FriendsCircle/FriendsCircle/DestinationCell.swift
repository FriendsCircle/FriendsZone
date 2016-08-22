//
//  DestinationCell.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/20/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import MapKit

class DestinationCell: UITableViewCell {
    
    let locationManager = CLLocationManager()
    let request = MKLocalSearchRequest()
    @IBOutlet var addDestinationButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

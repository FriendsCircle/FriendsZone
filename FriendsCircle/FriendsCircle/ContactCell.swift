//
//  ContactCell.swift
//  FriendsCircle
//
//  Created by Vu Nguyen on 8/13/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit


class ContactCell: UITableViewCell {
    
    @IBOutlet var firstNameLabel: UILabel!

    @IBOutlet var lastNameLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    var user: User! {
        didSet{
            firstNameLabel.text = user.name ?? "no name"
            
            phoneNumLabel.text = user.phoneNumber as! String
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

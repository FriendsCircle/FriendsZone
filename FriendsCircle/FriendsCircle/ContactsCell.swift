//
//  ContactsCell.swift
//  
//
//  Created by Vu Nguyen on 8/20/16.
//
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

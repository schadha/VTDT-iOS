//
//  UserProfileCell.swift
//  VTDT
//
//  Created by Sanchit Chadha on 11/1/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet var messageText: UILabel!
    @IBOutlet var userProfPic: FBProfilePictureView!
    @IBOutlet var barLocation: UILabel!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var atLabel: UILabel!
    @IBOutlet var friendLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

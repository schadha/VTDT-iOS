//
//  NewsFeedTableViewCell.swift
//  VTDT
//
//  Created by Ragan Walker on 10/21/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {


    @IBOutlet var messageText: UILabel!
    
    @IBOutlet var userProfPic: FBProfilePictureView!
    @IBOutlet var barLocation: UILabel!
    @IBOutlet var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

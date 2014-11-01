//
//  TableViewCell.swift
//  VTDT
//
//  Created by Ragan Walker on 10/30/14.
//  Copyright (c) 2014 Sanchit Chadha. All rights reserved.
//

import UIKit

class BarProfileCell: UITableViewCell {
    
    @IBOutlet var messageText: UILabel!
    
    @IBOutlet var userProfPic: FBProfilePictureView!
    @IBOutlet var barLocation: UILabel!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var specialDuration: UILabel!
    @IBOutlet var specialName: UILabel!
    @IBOutlet var specialDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

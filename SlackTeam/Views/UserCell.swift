//
//  UserCell.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/11/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealName: UILabel!
    @IBOutlet weak var userSlackName: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    
    override func awakeFromNib() {
        userImageView.layer.cornerRadius = 30
        userImageView.layer.borderWidth = 2.0
        userImageView.layer.borderColor = UIColor.darkGray.cgColor
        userImageView.layer.masksToBounds = true
    }
}

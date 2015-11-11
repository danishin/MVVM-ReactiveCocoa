//
//  UserCell.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-07.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import AlamofireImage

class UserCell: UITableViewCell {
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  
  var model: UserCellModel! {
    didSet {
      usernameLabel.text = model.username
      emailLabel.text = model.email
      userImageView.af_setImageWithURL(NSURL(string: model.imageUrl)!)
    }
  }
}

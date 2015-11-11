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
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  
  var user: User! {
    didSet {
      usernameLabel.text = user.username
      commentLabel.text = user.comment
      userImageView.af_setImageWithURL(NSURL(string: user.imageUrl)!)
    }
  }
}

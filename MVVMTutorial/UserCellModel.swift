//
//  UserCellViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-07.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

struct UserCellModel {
  let username: String
  let email: String
  let imageUrl: String
  
  static func from(user u: User) -> UserCellModel {
    return self.init(username: u.username, email: u.email, imageUrl: u.imageUrl)
  }
}
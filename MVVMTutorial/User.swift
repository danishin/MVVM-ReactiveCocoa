//
//  User.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-06.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Decodable

struct User {
  let name: String
  let email: String
  let username: String
  let password: String
}

extension User: Decodable {
  static func decode(j: AnyObject) throws -> User {
    return try User(
      name: j => "user" => "name" => "first",
      email: j => "user" => "email",
      username: j => "user" => "username",
      password: j => "user" => "password"
    )
  }
}


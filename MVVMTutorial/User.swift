//
//  User.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-06.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift
import Decodable

final class User: Object {
  dynamic var name: String = ""
  dynamic var email: String = ""
  dynamic var username: String = ""
  dynamic var password: String = ""
  dynamic var imageUrl: String = ""
  
  override static func primaryKey() -> String? { return "email" }
}

extension User: Decodable {
  static func decode(j: AnyObject) throws -> User {
    let u = User()
    
    u.name =      try j => "user" => "name" => "first"
    u.email =     try j => "user" => "email"
    u.username =  try j => "user" => "username"
    u.password =  try j => "user" => "password"
    u.imageUrl =  try j => "user" => "picture" => "medium"
    
    return u
  }
}


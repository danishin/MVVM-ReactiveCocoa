//
//  User.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-06.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import RealmSwift
import Decodable

final class User: Object {
  dynamic var username: String = ""
  dynamic var name: String = ""
  dynamic var email: String = ""
  private dynamic var password: String = ""
  dynamic var imageUrl: String = ""
  
  dynamic var comment: String = ""
  
  override static func primaryKey() -> String? { return "username" }
}

extension User: Decodable {
  var decorated_username: String { return "\(name): \(username)" }
  
  static func decode(j: AnyObject) throws -> User {
    let u = User()
    
    u.name =      try j => "user" => "name" => "first"
    u.email =     try j => "user" => "email"
    u.username =  try j => "user" => "username"
    u.password =  try j => "user" => "password"
    u.imageUrl =  try j => "user" => "picture" => "medium"
    
    u.comment = ""
    
    return u
  }
}


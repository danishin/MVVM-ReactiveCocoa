//
//  LocalUser.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-10.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation

// NB: Modifiable is type-level constraint to tell if the field is modifiable. `Void` means non-modifiable while `Bool` mean modifiable.
protocol LocalUserKey {
  typealias Value;
  typealias Modifiable;
  static var name: String { get }
}

struct UserId: LocalUserKey   { typealias Value = Int; typealias Modifiable = Void; static let name = "user_id" }
struct Username: LocalUserKey { typealias Value = String; typealias Modifiable = Bool; static let name = "username" }

class LocalUser {
  func get<K: LocalUserKey>(k: K.Type) -> K.Value {
    if let value = NSUserDefaults.standardUserDefaults().objectForKey(k.name) as? K.Value {
      return value
    } else {
      fatalError("cannot find \(k.name)")
    }
  }
  
  // NB: Curried for type inference
  private func _set<K: LocalUserKey>(k: K.Type)(value: K.Value) {
    NSUserDefaults.standardUserDefaults().setObject(value as! NSObject, forKey: k.name)
  }
  
  func set<K: LocalUserKey where K.Modifiable == Bool>(k: K.Type)(value: K.Value) {
    _set(k)(value: value)
  }
  
  func authenticated(user_id user_id: Int, username: String) {
    _set(UserId)(value: user_id)
    _set(Username)(value: username)
  }
}

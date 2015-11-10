//
//  Config.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-07.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol Config {
  /* Overridable */
  var BaseURL: String { get }
  func RealmConfig(user_id: Int) -> Realm.Configuration
}

extension Config {
  /* Non-Overridable */
}

class DefaultConfig: Config {
  let BaseURL = "Run"
  func RealmConfig(user_id: Int) -> Realm.Configuration {
    var config = Realm.Configuration()
    
    config.path = NSURL.fileURLWithPath(config.path!)
      .URLByDeletingLastPathComponent?
      .URLByAppendingPathComponent(String(user_id))
      .URLByAppendingPathExtension("realm")
      .path
    
    return config
  }
}

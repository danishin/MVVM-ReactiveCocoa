//
//  LocalUser.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-10.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import SwiftyUserDefaults

private extension DefaultsKeys {
  static let user_id = DefaultsKey<Int?>("user_id")
}

class LocalUser {
  var user_id: Int { return get(Defaults[.user_id]) }
  
  private func get<A>(a: A?) -> A {
    if let a = a {
      return a
    } else {
      // FIXME: Handle Error.
      fatalError()
    }
  }
  
  func authenticated(user_id: Int) {
    Defaults[.user_id] = user_id
  }
}

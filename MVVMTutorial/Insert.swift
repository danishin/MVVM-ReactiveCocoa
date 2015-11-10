//
//  Insert.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension Realm {
  var notifier: Notifier {
    if let notifier = objects(Notifier).first {
      return notifier
    } else {
      let notifier = Notifier()
      try! write { add(notifier) }
      return notifier
    }
  }
}

protocol Insert: DBRequest {}
extension Insert { var queue: dispatch_queue_t { return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) } }

struct InsertUser: Insert {
  let user: User
  
  func query(rc: RealmConfig) throws -> Void {
    let r = try Realm(configuration: rc)
    try r.write { r.add(user, update: true) }
  }
}

struct InsertUsers: Insert {
  let users: [User]
  
  func query(rc: RealmConfig) throws -> Void {
    let r = try Realm(configuration: rc)
    try r.write { r.notifier.users.appendContentsOf(users) }
  }
}
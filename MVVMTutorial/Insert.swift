//
//  Insert.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation

protocol Insert: DBRequest {}
extension Insert { var queue: dispatch_queue_t { return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) } }

struct InsertUser: Insert {
  let user: User
  func query() throws -> Void {
    let r = try realm()
    try r.write { r.add(user, update: true) }
  }
}

struct InsertUsers: Insert {
  let users: [User]
  func query() throws -> Void {
    let r = try realm()
    let notifier = r.objects(Notifier).first!
    try r.write {
      notifier.users.appendContentsOf(users)
    }
  }
}
//
//  Update.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import RealmSwift

protocol Update: DBRequest {}
extension Update { var queue: dispatch_queue_t { return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) } }

struct UpdateUserComment: Update {
  let username: String, comment: String
  
  func query(rc: RealmConfig) throws -> Void {
    let r = try Realm(configuration: rc)

    try r.write { r.objects(User).filter("username = %@", username).first?.comment = comment }
  }
}

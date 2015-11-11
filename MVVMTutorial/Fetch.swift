//
//  Fetch.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import RealmSwift

protocol Fetch: DBRequest {}
extension Fetch { var queue: dispatch_queue_t { return dispatch_get_main_queue() } }

struct FetchUsers: Fetch {
  func query(rc: RealmConfig) throws -> Results<User> {
    let r = try Realm(configuration: rc)
    return r.objects(User).sorted("name")
  }
}

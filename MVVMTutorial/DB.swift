//
//  DB.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift
import BrightFutures
import Result

protocol DBRequest {
  typealias Result
  var queue: dispatch_queue_t { get }
  func query() throws -> Result
}
extension DBRequest {
  func realm() throws -> Realm { return try Realm() }
}

protocol DB {
  var notifier: Notifier { get }
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError>
}

class RealmDB: DB {
  let notifier: Notifier
  
  init(notifier: Notifier) { self.notifier = notifier }
  
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError> {
    return future { try dr.query() }(AppError.DB)
  }
}
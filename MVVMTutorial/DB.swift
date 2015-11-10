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

typealias RealmConfig = Realm.Configuration

protocol DBRequest {
  typealias Result
  var queue: dispatch_queue_t { get }
  func query(rc: RealmConfig) throws -> Result
}

protocol DB {
  var notifier: Notifier { get }
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError>
}

class RealmDB: DB {
  let notifier: Notifier = Notifier.sharedInstance()
  private let rc: RealmConfig
  
  init(config: Config, localUser: LocalUser) { self.rc = config.RealmConfig(localUser.user_id) }
  
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError> {
    return future { try dr.query(self.rc) }(AppError.DB)
  }
}
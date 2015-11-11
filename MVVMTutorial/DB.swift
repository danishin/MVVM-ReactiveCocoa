//
//  DB.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import RealmSwift
import BrightFutures
import Result

extension Realm {
  var supervisor: Supervisor { return Supervisor.sharedInstance(configuration) }
}

typealias RealmConfig = Realm.Configuration

protocol DBRequest {
  typealias Result
  var queue: dispatch_queue_t { get }
  func query(rc: RealmConfig) throws -> Result
}

protocol DB {
  func supervisor() ->  Supervisor
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError>
}

class RealmDB: DB {
  func supervisor() -> Supervisor { return Supervisor.sharedInstance(rc) }
  private let rc: RealmConfig
  
  init(config: Config, localUser: LocalUser) { self.rc = config.RealmConfig(localUser.get(Username)) }
  
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError> {
    return future { try dr.query(self.rc) }(AppError.DB)
  }
}
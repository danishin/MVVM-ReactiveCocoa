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
import ReactiveCocoa
import Result

typealias RealmConfig = Realm.Configuration

protocol DBRequest {
  typealias Result
  var queue: dispatch_queue_t { get }
  func query(r: Realm, m: Model) throws -> Result
}

protocol DBStreamRequest {
  typealias Result
  func stream(m: Model) throws -> Result
}

class DB: DB {
  private let rc: RealmConfig
  
  init(config: Config, localUser: LocalUser) { self.rc = config.RealmConfig(localUser.get(Username)) }
  
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError> {
    return future {
      let realm = Realm(configuration: self.rc)
      try dr.query(realm, m: Model.sharedInstance(realm))
    }(AppError.DB)
  }
  
  func stream<DSR: DBStreamRequest>(dsr: DSR.Type) -> SignalProducer<DSR.Result, AppError> {
//    fatalError()
  }
}




















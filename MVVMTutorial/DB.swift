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

final class Supervisor: Object {
  let users = List<User>()
}

extension Supervisor {
  static func sharedInstance(rc: RealmConfig) -> Supervisor {
    let realm = try! Realm(configuration: rc)
    if let supervisor = realm.objects(Supervisor).first { return supervisor }
    
    let supervisor = Supervisor()
    try! realm.write { realm.add(supervisor) }
    
    return supervisor
  }
  
  func observeUsers() -> SignalProducer<List<User>, ReactiveCocoa.NoError> {
    
    // FIXME: How to map over RLMArray?
    return DynamicProperty(object: self, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).map { [unowned self] _ in self.users }
  }
}

extension Realm {
  var supervisor: Supervisor { return Supervisor.sharedInstance(configuration) }
}

typealias RealmConfig = Realm.Configuration

protocol DBRequest {
  typealias Result
  var queue: dispatch_queue_t { get }
  func query(r: Realm) throws -> Result
}

protocol DBStreamRequest {
  typealias Result
  func query(r: Realm) throws -> Result
}

protocol DB {
  func supervisor() ->  Supervisor
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError>
  func stream<DSR: DBStreamRequest>(dsr: DSR) -> SignalProducer<DSR.Result, AppError>
}

class RealmDB: DB {
  func supervisor() -> Supervisor { return Supervisor.sharedInstance(rc) }
  private let rc: RealmConfig
  
  init(config: Config, localUser: LocalUser) { self.rc = config.RealmConfig(localUser.get(Username)) }
  
  func exec<DR: DBRequest>(dr: DR) -> Future<DR.Result, AppError> {
    return future { try dr.query(try Realm(configuration: self.rc)) }(AppError.DB)
  }
  
  func stream<DSR: DBStreamRequest>(dsr: DSR) -> SignalProducer<DSR.Result, AppError> {
    fatalError()
  }
}
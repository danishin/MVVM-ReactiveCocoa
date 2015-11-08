//
//  DB.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift
import ReactiveCocoa

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
  func exec<DR: DBRequest>(dr: DR) -> SignalProducer<DR.Result, AppError>
}


class RealmDB: DB {
  let notifier: Notifier
  
  init(notifier: Notifier) { self.notifier = notifier }
  
  func exec<DR: DBRequest>(dr: DR) -> SignalProducer<DR.Result, AppError> {
    return SignalProducer { observer, _ in
      dispatch_async(dr.queue) {
        do {
          let result = try dr.query()
          observer.sendNext(result)
          observer.sendCompleted()
        } catch let error as NSError {
          observer.sendFailed(AppError.DB(error))
        }
      }
    }
  }
}
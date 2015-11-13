//
//  Stream.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-13.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import RealmSwift

struct StreamUsers: DBStreamRequest {
  static func stream(m: Model) -> SignalProducer<List<User>, AppError> {
    return DynamicProperty(object: m, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).map { [unowned self] _ in m.users }
  }
}

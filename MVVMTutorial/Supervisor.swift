//
//  Notifier.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import RealmSwift
import ReactiveCocoa

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
  
  func observeUsers() -> SignalProducer<List<User>, NoError> {
    // FIXME: How to map over RLMArray?
    return DynamicProperty(object: self, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).map { [unowned self] _ in self.users }
  }
}
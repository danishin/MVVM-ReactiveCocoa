//
//  Notifier.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift
import ReactiveCocoa

final class Model: Object {
  let users = List<User>()
}

extension Model {
  static func sharedInstance(realm: Realm) throws -> Model {
    if let model = realm.objects(Model).first { return model }
    
    let model = Model()
    try realm.write { realm.add(model) }
    
    return model
  }
  
//  func observeUsers() -> SignalProducer<List<User>, ReactiveCocoa.NoError> {
//    
//    // FIXME: How to map over RLMArray?
//    return DynamicProperty(object: self, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).map { [unowned self] _ in self.users }
//  }
}

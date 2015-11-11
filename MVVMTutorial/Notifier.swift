//
//  Notifier.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift

// FIXME: Use better name
final class Supervisor: Object {
  let users = List<User>()
}

extension Supervisor {
  static func sharedInstance(rc: RealmConfig) -> Supervisor {
    let realm = try! Realm(configuration: rc)
    if let notifier = realm.objects(Supervisor).first { return notifier }
    
    let supervisor = Supervisor()
    try! realm.write { realm.add(supervisor) }
    
    return supervisor
  }
}
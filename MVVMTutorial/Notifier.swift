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
final class Notifier: Object {
  let users = List<User>()
}

extension Notifier {
  static func create() -> Notifier {
    let realm = try! Realm()
    if let notifier = realm.objects(Notifier).first { return notifier }
    
    let notifier = Notifier()
    try! realm.write { realm.add(notifier) }
    
    return notifier
  }
}
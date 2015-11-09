//
//  ViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Realm
import RealmSwift
import ReactiveCocoa
import Rex
import Swinject

final class ViewModel {
  let title = MutableProperty("")
  let cell_models = MutableProperty<[UserCellModel]>([])
  let isSearching = MutableProperty(false)
  
  var search: Action<(Int, String), Void, AppError>!
  
  init(api: API, db: DB) {
    // FIXME: How to map over RLMArray?
    cell_models <~ DynamicProperty(object: db.notifier, keyPath: "users").producer.map { _ in db.notifier.users.map(UserCellModel.from) }
    
    search = Action {
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap(.Concat) { r in db.exec(InsertUsers(users: r.users))
          .on(next: { [weak self] in
            self?.title.value = "Current Fetched Country: \(r.nationality)"
          })}
        .map { _ in () }
      }
    
    isSearching <~ search.executing.producer.skipRepeats().observeOn(QueueScheduler.mainQueueScheduler)
  }
}
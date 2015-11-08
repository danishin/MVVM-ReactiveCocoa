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
  var searchImage: Action<(Int, String), Void, AppError>!
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  init(api: API, db: DB) {
    // FIXME: How to map over RLMArray?
    cell_models <~ DynamicProperty(object: db.notifier, keyPath: "users").producer.map { _ in db.notifier.users.map(UserCellModel.from) }
    
    searchImage = Action {
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap(.Concat) { r in db.exec(InsertUsers(users: r.users))
          .on(next: { [weak self] in self?.title.value = "Current Fetched Country: \(r.nationality)" })}
        .map { _ in () }
      }
  }
}
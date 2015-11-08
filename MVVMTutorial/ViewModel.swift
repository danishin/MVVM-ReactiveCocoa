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
  let notifier: Notifier
  
  let title = MutableProperty("")
  var searchImage: Action<(Int, String), Void, AppError>!
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  let disposable: Disposable
  
  
  init(api: API, db: DB) {
//    let a: RLMArray = RLMArray(objectClassName: "")
//    a.objectsWithPredicate(NSPredicate())
    
    
    
    
    self.notifier = db.notifier
//    cell_models <~ DynamicProperty(object: db.notifier, keyPath: "users").producer.on(next: { print($0) })
////      .map { $0! }
//      .map { ($0 as! List<User>).map(UserCellModel.from) }
    disposable = DynamicProperty(object: self.notifier, keyPath: "users").producer
      .on(next: { print($0) })
      .map { ($0 as? List<User>) }
      .on(next: { print($0) })
      .start()
    
    searchImage = Action {
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap(.Concat) { r in db.exec(InsertUsers(users: r.users))
          .on(next: { dispatch_async(dispatch_get_main_queue()) { print(self.notifier.users) } })
          .on(next: { [weak self] in self?.title.value = "Current Fetched Country: \(r.nationality)" })}
        .map { _ in () }
      }
  }
}
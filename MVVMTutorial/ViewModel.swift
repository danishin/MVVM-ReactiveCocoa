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

private extension CocoaAction {
  static var disabled: CocoaAction {
    return CocoaAction(Action<Void, Void, NoError>.rex_disabled, input: ())
  }
}

final class ViewModel {
  let title = MutableProperty("")
  let userNum = MutableProperty(0)
  let gender = MutableProperty("")
  let isSearching = MutableProperty(false)
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  let search = MutableProperty(CocoaAction.disabled)
  
  private var searchAction: Action<(Int, String), Void, AppError>!
  
  private let searchEnabled = MutableProperty(false)
  
  init(api: API, db: DB) {
    let searchStarted = isSearching.producer.filterMap { $0 ? () : nil }
    
    userNum <~ searchStarted.map { 0 }
    gender <~ searchStarted.map { "" }
    
    searchEnabled <~ combineLatest(userNum.producer.map { $0 != 0 }, gender.producer.map { $0 != "" }).map { $0 && $1 }
    
    // FIXME: How to map over RLMArray?
    cell_models <~ DynamicProperty(object: db.notifier, keyPath: "users").producer.map { _ in db.notifier.users.map(UserCellModel.from) }
    
    searchAction = Action(enabledIf: searchEnabled) {
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap(.Concat) { r in db.exec(InsertUsers(users: r.users))
          .on(next: { [weak self] in
            self?.title.value = "Current Fetched Country: \(r.nationality)"
            })}
        .map { _ in () }
    }
    
    search <~ combineLatest(userNum.producer, gender.producer).map { [unowned self] in CocoaAction(self.searchAction, input: ($0, $1)) }
    
    isSearching <~ searchAction.executing.producer.skipRepeats().observeOn(QueueScheduler.mainQueueScheduler)
  }
}
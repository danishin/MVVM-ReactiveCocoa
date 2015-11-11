//
//  ViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa
import Rex
import BrightFutures
import Realm
import RealmSwift

private extension CocoaAction {
  static var disabled: CocoaAction {
    return CocoaAction(Action<Void, Void, ReactiveCocoa.NoError>.rex_disabled, input: ())
  }
}

final class ViewModel {
  // Properties
  let title = MutableProperty("")
  let userNum = MutableProperty(0)
  let gender = MutableProperty("")
  
  // Outputs
  let isSearching = MutableProperty(false)
  let users = MutableProperty<List<User>>(List())
  
  // Actions
  let search = MutableProperty(CocoaAction.disabled)
  
  // Action Helpers
  private let searchEnabled = MutableProperty(false)
  private lazy var searchAction: Action<(Int, String), Void, AppError> = { [unowned self] in
    return Action(enabledIf: self.searchEnabled) {
      self.api.exec(GETRandomUser(userNum: $0, gender: $1))
        .debug("action")
        .flatMap { r in self.db.exec(InsertUsers(users: r.users)).onSuccess { [weak self] in self?.title.value = "Current Fetched Country: \(r.nationality)" }}
        .map { _ in () }
        .toSignalProducer()
    }
  }()
  
  // Dependencies
  private let api: API
  private let db: DB
  
  init(api: API, db: DB, localUser: LocalUser) {
    self.api = api
    self.db = db
    
    // NB: Let's pretend this user is authenticated and has user_id of 1
    localUser.authenticated(1)
    
    let searchStarted = isSearching.producer.filterMap { $0 ? () : nil }
    userNum <~ searchStarted.map { 0 }
    gender <~ searchStarted.map { "" }
    
    searchEnabled <~ combineLatest(userNum.producer.map { $0 != 0 }, gender.producer.map { $0 != "" }).map { $0 && $1 }
    
    // FIXME: How to map over RLMArray?
    users <~ DynamicProperty(object: db.notifier, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).debug("users").map { _ in db.notifier.users }
    
    search <~ combineLatest(userNum.producer, gender.producer).map { [unowned self] in CocoaAction(self.searchAction, input: ($0, $1)) }
    
    isSearching <~ searchAction.executing.producer.skipRepeats().observeOn(QueueScheduler.mainQueueScheduler)
  }
  
  // MARK: Data Source
  func numberOfUsersInSection(section: Int) -> Int {
    return users.value.count
  }
  
//  func userCellModelForRowAtIndexPath()
  
}
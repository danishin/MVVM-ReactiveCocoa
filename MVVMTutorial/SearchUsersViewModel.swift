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

final class SearchUsersViewModel {
  // Inputs
  let userNum = MutableProperty(0)
  let gender = MutableProperty("")
  
  // Outputs
  let title = MutableProperty("")
  let buttonTitle = MutableProperty("Search")
  let isSearching = MutableProperty(false)
  
  // Models
  let users = MutableProperty<List<User>>(List())
  
  // Actions
  let search = MutableProperty(CocoaAction.disabled)
  
  // Action Helpers
  private let searchEnabled = MutableProperty(false)
  private lazy var searchAction: Action<(Int, String), Void, AppError> = { [unowned self] in
    return Action(enabledIf: self.searchEnabled) {
      self.api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap { r in self.db.exec(InsertUsers(users: r.users)).onSuccess { [weak self] in self?.title.value = "Current Fetched Country: \(r.nationality)" }}
        .map { _ in () }
        .toSignalProducer()
    }
  }()
  
  // Dependencies
  private let api: API
  private let db: DB
  private let supervisor: Supervisor
  
  init(api: API, db: DB) {
    self.api = api
    self.db = db
    self.supervisor = db.supervisor()
    
    let searchStarted = isSearching.producer.filterMap { $0 ? () : nil }
    userNum <~ searchStarted.map { 0 }
    gender <~ searchStarted.map { "" }
    
    buttonTitle <~ isSearching.producer.map { $0 ? "Searching..." : "Search" }
    
    searchEnabled <~ combineLatest(
      userNum.producer.map { $0 != 0 },
      gender.producer.map { $0 != "" }
    ).map { $0 && $1 }
    
    isSearching <~ searchAction.executing.producer.skipRepeats().observeOn(QueueScheduler.mainQueueScheduler)
    users <~ supervisor.observeUsers()
    search <~ combineLatest(userNum.producer, gender.producer).map { [unowned self] in CocoaAction(self.searchAction, input: ($0, $1)) }
  }
}
























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
import RealmSwift

final class UsersViewModel {
  // Inputs
  let userNum = MutableProperty(0)
  let gender = MutableProperty("")
  
  // Outputs
  let title = MutableProperty("")
  let buttonTitle = MutableProperty("Search")
  let isSearching = MutableProperty(false)
  let (reloadSignal, reloadObserver) = Signal<Void, ReactiveCocoa.NoError>.pipe()
  
  // Actions
  let search = MutableProperty(CocoaAction.disabled)
  
  // Models
  private let users = MutableProperty<List<User>>(List())
  
  // Action Helpers
  private let searchEnabled = MutableProperty(false)
  
  // Retained Dependencies
  private let db: DB
  private let supervisor: Supervisor
  
  init(api: API, db: DB) {
    self.db = db
    self.supervisor = db.supervisor()
    
    let searchAction = Action(enabledIf: self.searchEnabled) { [weak self] in
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .flatMap { r in db.exec(InsertUsers(users: r.users)).onSuccess { self?.title.value = "Current Fetched Country: \(r.nationality)" }}
        .map { _ in () }
        .toSignalProducer()
    }
    
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
    search <~ combineLatest(userNum.producer, gender.producer).map { CocoaAction(searchAction, input: ($0, $1)) }
   
    users.producer.startWithNext { [weak self] _ in self?.reloadObserver.sendNext(()) }
  }
  
  var usersCount: Int { return users.value.count }
  func userAt(indexPath: NSIndexPath) -> User {
    return users.value[indexPath.row]
  }
  
  func editCommentVM(indexPath: NSIndexPath) -> EditCommentViewModel {
    return EditCommentViewModel(username: userAt(indexPath).username, db: db, reloadObserver: reloadObserver)
  }
}
























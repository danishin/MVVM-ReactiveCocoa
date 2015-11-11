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
  let userCellModels = MutableProperty<[UserCellModel]>([])
  
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
    
    searchEnabled <~ combineLatest(userNum.producer.map { $0 != 0 }, gender.producer.map { $0 != "" }).map { $0 && $1 }
    
    // FIXME: How to map over RLMArray?
    userCellModels <~ DynamicProperty(object: supervisor, keyPath: "users").producer.observeOn(QueueScheduler.mainQueueScheduler).map { [unowned self] _ in self.supervisor.users.map(UserCellModel.from) }
    
    search <~ combineLatest(userNum.producer, gender.producer).map { [unowned self] in CocoaAction(self.searchAction, input: ($0, $1)) }
    
    isSearching <~ searchAction.executing.producer.skipRepeats().observeOn(QueueScheduler.mainQueueScheduler)
  }
  
  // MARK: Data Source
  func numberOfRowsInSection(section: Int) -> Int {
    return userCellModels.value.count
  }
  
//  func userCellModelForRowAtIndexPath()
  
}
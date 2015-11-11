//
//  EditCommentViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

class EditCommentViewModel {
  // Inputs
  let comment = MutableProperty("")
  
  // Actions
  let save = MutableProperty(CocoaAction.disabled)
  let (doneSignal, doneObserver) = Signal<Void, NoError>.pipe()
  
  // Action Helpers
  private let saveEnabled = MutableProperty(false)
  
  init(username: String, db: DB, reloadObserver: Observer<Void, NoError>) {
    saveEnabled <~ comment.producer.map { !$0.isEmpty }
    
    let saveAction: Action<String, Void, AppError> = Action(enabledIf: self.saveEnabled) {
      db.exec(UpdateUserComment(username: username, comment: $0))
        .onSuccess { [unowned self] _ in
          reloadObserver.sendNext(())
          self.doneObserver.sendCompleted()
        }
        .toSignalProducer()
    }
    
    save <~ comment.producer.map { CocoaAction(saveAction, input: $0) }
  }
}
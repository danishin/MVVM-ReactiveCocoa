//
//  LoginViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

class LoginViewModel {
  
  // Inputs
  let username = MutableProperty("")
  let password = MutableProperty("")
  
  // Outputs
  let loginEnabled = MutableProperty(false)
  let loggedIn = MutableProperty(false)
  
  // Actions
  let login = MutableProperty(CocoaAction.disabled)
  
  // Action Helpers
  private lazy var loginAction: Action<String, Void, NoError> = { [unowned self] in
    return Action(enabledIf: self.loginEnabled) {
      self.localUser.authenticated(user_id: 1, username: $0)
      self.loggedIn.value = true
      
      return SignalProducer.empty
    }
  }()
  
  // Dependencies
  private let localUser: LocalUser
  
  init(localUser: LocalUser) {
    self.localUser = localUser
    
    loginEnabled <~ combineLatest(
      username.producer.map { $0.characters.count > 5 },
      password.producer.map { $0.characters.count > 5 }
    ).map { $0 && $1 }
    
    login <~ combineLatest(username.producer, password.producer).map { [unowned self] u, p in CocoaAction(self.loginAction, input: u) }
  }
}

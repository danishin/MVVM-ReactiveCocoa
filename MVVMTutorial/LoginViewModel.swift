//
//  LoginViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

class LoginViewModel: ViewModel {
  
  // Inputs
  let username = MutableProperty("")
  let password = MutableProperty("")
  
  // Outputs
  let loginEnabled = MutableProperty(false)
  let loggedIn = MutableProperty(false)
  
  // Actions
  let login = MutableProperty(CocoaAction.disabled)
  
  init(localUser: LocalUser) {
    let loginAction: Action<String, Void, NoError> = Action(enabledIf: self.loginEnabled) {
      localUser.authenticated(user_id: 1, username: $0)
      self.loggedIn.value = true
      
      return SignalProducer.empty
    }
    
    loginEnabled <~ combineLatest(
      username.producer.map { $0.characters.count > 5 },
      password.producer.map { $0.characters.count > 5 }
    ).map { $0 && $1 }
    
    login <~ combineLatest(username.producer, password.producer).map { u, p in CocoaAction(loginAction, input: u) }
  }
}

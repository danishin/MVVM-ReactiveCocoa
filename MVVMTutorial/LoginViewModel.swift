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
  
  init(localUser: LocalUser) {
    let loginAction: Action<String, Void, NoError> = Action(enabledIf: loginEnabled) { [unowned self] username in
      localUser.authenticated(user_id: 1, username: username)
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

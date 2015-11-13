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
  let text = MutableProperty("")
  
  // Outputs
  let loginEnabled = MutableProperty(false)
  let loggedIn = MutableProperty(false)
  let echo = MutableProperty("")
  
  // Actions
  let login = MutableProperty(CocoaAction.disabled)
  
  // Retained Dependencies
  let echoSocket: EchoSocket
  
  init(localUser: LocalUser, echoSocket: EchoSocket) {
    self.echoSocket = echoSocket
    echoSocket.connect()
    
    echoSocket.text <~ text
    echo <~ echoSocket.echo
    
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

//
//  ViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

class ViewModel {
  let title: ConstantProperty<String>
  
  let text = MutableProperty("")
  
  let username = MutableProperty("")
  let email = MutableProperty("")
  
  let isIdle = MutableProperty(true)
  
  var searchImage: CocoaAction!
  
  init(http: Http, titleName: String) {
    title = ConstantProperty(titleName)
    
    let action: Action<String, GETRandomUser.ResponseData, AppError> = Action(enabledIf: isIdle) { [unowned self] in
      self.isIdle.value = false
      
      return http.exec(GETRandomUser(keyword: $0))
        .on(next: {
          print($0)
          let user = $0.users.first!
          self.username.value = user.username
          self.email.value = user.email
          self.isIdle.value = true
        })
    }
    
    searchImage = CocoaAction(action, input: text.value)
    
//    text.producer
  }
}
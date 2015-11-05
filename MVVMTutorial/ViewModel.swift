//
//  ViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

class ViewModel {
  let text = MutableProperty<String>("")
//  let searchImage: SignalProducer<UIImage, AppError>
  var searchImage: CocoaAction!
  let isIdle = MutableProperty<Bool>(true)
  let username = MutableProperty<String>("")
  let email = MutableProperty<String>("")
  
  init(http: Http) {
    searchImage = CocoaAction(Action(enabledIf: isIdle) {
      http.exec(GETRandomUser(keyword: $0))
        .on(next: {
          print($0)
          self.username.value = $0.username
          self.email.value = $0.email
        })
      }, input: text.value)
//    searchImage = http.exec(GETGoogleImage(keyword: text.value)).map { a in UIImage() }.on(next: { _ in print("FETCHING !") })
    
//    let _ = Action(enabledIf: isIdle) { (text: String) -> SignalProducer<GETRandomUser.ResponseData, AppError> in
//      self.isIdle.value = false
//      return http.exec(GETRandomUser(keyword: text))
//        .on(next: { _ in self.isIdle.value = false })
//    }
  }
}
//
//  Extensions.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

@testable import MVVMTutorial

extension MutableProperty {
  func success(name: String?, onNext: Value -> Void) -> Disposable {
    if let name = name {
      return producer.debug(name).startWithNext(onNext)
    } else {
      return producer.startWithNext(onNext)
    }
  }
  
  func success(onNext: Value -> Void) -> Disposable {
    return success(nil, onNext: onNext)
  }
}

extension MutableProperty where Value: CocoaAction {
  func run() -> Disposable {
    return success { $0.execute(nil) }
  }
}


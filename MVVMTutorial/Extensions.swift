//
//  Extensions.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-10.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType {
  func debug(name: String = "Unknown") -> SignalProducer<Value, Error> {
    func p(s: AnyObject) { print("DEBUG [\(name)]: \(s)") }
    
    return self.on(
      started: { p("Started") },
      failed: { p("Failed: \($0)") },
      completed: { p("Completed") },
      terminated: { p("Terminated") },
      disposed: { p("Disposed") },
      next: { p("Next: \($0)") }
    )
  }
}
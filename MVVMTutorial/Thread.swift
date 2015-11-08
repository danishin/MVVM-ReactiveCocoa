//
//  Thread.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-08.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation

enum Thread {
  case Main
  case Background
  
  var queue: dispatch_queue_t {
    switch self {
    case .Main: return dispatch_get_main_queue()
    case .Background: return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    }
  }
}
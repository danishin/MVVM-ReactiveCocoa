//
//  AppError.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation

enum AppError: ErrorType {
  case NonError
  case Network(ErrorType)
  case DB(ErrorType)
}

struct CustomError: ErrorType {
  let desc: String
}


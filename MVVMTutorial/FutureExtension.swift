//
//  FutureExtension.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-09.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import BrightFutures
import Result
import ReactiveCocoa

func future<A>(f: () throws -> A)(_ g: ErrorType -> AppError) -> Future<A, AppError> {
  return future {
    do {
      let a = try f()
      return Result(value: a)
    } catch let e {
      return Result(error: g(e))
    }
  }
}

func future<A>(error e: AppError) -> Future<A, AppError> {
  return future(Result<A, AppError>(error: e))
}

extension Future {
  func toSignalProducer() -> SignalProducer<T, E> {
    return SignalProducer { observer, _ in
      self.onComplete { switch $0 {
      case let .Failure(e):
        observer.sendFailed(e)
        
      case let .Success(t):
        observer.sendNext(t)
        observer.sendCompleted()
      }}
    }
  }
  
  func debug(name: String = "Unknown") -> Future<T, E> {
    return onComplete {
      switch $0 {
      case let .Success(t): print("DEBUG Future [\(name)]: Success: \(t)")
      case let .Failure(e): print("DEBUG Future [\(name)]: Failure: \(e)")
      }
    }
  }
}

//
//  Extensions.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-10.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa
import Swinject
import BrightFutures
import Result

/* ReactiveCocoa */
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

extension UIControl {
  func property(keyPath: String) -> DynamicProperty {
    return DynamicProperty(object: self, keyPath: keyPath)
  }
}

extension UITextField {
  var textSignalProducer: SignalProducer<String, ReactiveCocoa.NoError> {
    return rac_textSignal().toSignalProducer().ignoreError().map { ($0 as? String) ?? "" }
  }
}

extension MutablePropertyType {
  func debug() -> Self {
    self.producer.debug()
    return self
  }
}

extension CocoaAction {
  static var disabled: CocoaAction {
    return CocoaAction(Action<Void, Void, ReactiveCocoa.NoError>.rex_disabled, input: ())
  }
}


/* Swinject */
extension Resolvable {
  func get<Service>(serviceType: Service.Type) -> Service {
    guard let service = resolve(serviceType) else { fatalError("DI Error: Failed to resolve \(serviceType)") }
    return service
  }
  
  // TODO: Use HList for args?
  func get<Service, Arg1>(serviceType: Service.Type, arg1: Arg1) -> Service {
    guard let service = resolve(serviceType, arg1: arg1) else { fatalError("DI Error: Failed to resolve \(serviceType) with \(arg1)") }
    return service
  }
}

/* BrightFutures */
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


//
//  Extensions.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa


infix operator =>> { associativity left precedence 160 }
//func =>> <T>(l: UIControl, r: SignalProducer<T, AppError>) {
//  l.toSignalProducer()
//    .convertError { _ in AppError.NonError }
//    .flatMap(.Concat) { _ in r }
//    .start { _ in }
//  
////  l.addTarget(r, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
//}
func =>> (l: UIControl, r: CocoaAction) {
    l.addTarget(r, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
}


////////////////////////////////
// UIControl
////////////////////////////////
extension UIControl {
  func toSignalProducer<A>(controlEvents: UIControlEvents = .TouchUpInside, f: AnyObject? -> A) -> SignalProducer<A, NoError> {
    return rac_signalForControlEvents(controlEvents).toSignalProducer().ignoreError().map(f)
  }
  
  func toSignalProducer(controlEvents: UIControlEvents = .TouchUpInside) -> SignalProducer<Void, NoError> {
    return toSignalProducer { _ in () }
  }
}

////////////////////////////////
// UILabel
////////////////////////////////
//extension UILabel {
//  var rac_text: DynamicProperty {
//    return DynamicProperty(object: self, keyPath: "text")
//  }
//}

////////////////////////////////
// NSURLSession
////////////////////////////////
extension NSURLSession {
  func toSignalProducer(path: String, errorMapper: NSError -> AppError) -> SignalProducer<(NSData, NSURLResponse), AppError> {
    return rac_dataWithRequest(NSURLRequest(URL: NSURL(string: path)!)).mapError(errorMapper)
  }
}

////////////////////////////////
// SignalProducerType
////////////////////////////////
extension SignalProducerType where E: ErrorType {
  func convertError(f: E -> AppError) -> SignalProducer<T, AppError> {
    return flatMapError { e in
      let ae = f(e)
      return SignalProducer<T, AppError>(error: ae)
      
//      if ae == AppError.NonError { return SignalProducer<T, AppError>.empty }
//      else { return SignalProducer<T, AppError>(error: ae) }
    }
  }
  
  func ignoreError() -> SignalProducer<T, NoError> {
    return flatMapError { e in
      return SignalProducer<T, NoError>.empty
    }
  }
}

////////////////////////////////
// UIImageView
////////////////////////////////
extension UIImageView {
  var rac_image: DynamicProperty {
    return DynamicProperty(object: self, keyPath: "image")
  }
}
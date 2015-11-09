//
//  Http.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import BrightFutures

private extension Request {
//  func toSignalProducer<HR: APIRequest>(Hr: HR.Type) -> SignalProducer<HR.ResponseData, AppError> {
//    return SignalProducer { (observer, _) in
//      self.responseJSON { r in
//        if let error = r.result.error { fatalError(error.description) }
//        guard let json = r.result.value else { fatalError() }
//        
//        let responseData = try! Hr.ResponseData.decode(json)
//        
//        observer.sendNext(responseData)
//        observer.sendCompleted()
//      }
//    }
//  }
  func toFuture<HR: APIRequest>(Hr: HR.Type) -> Future<HR.ResponseData, AppError> {
    let p = Promise<HR.ResponseData, AppError>()
    
    self.responseJSON { r in
      if let e = r.result.error { return p.failure(AppError.Network(e))  }
      guard let json = r.result.value else { return p.failure(AppError.Network(CustomError(desc: ""))) }
      
      do {
        let responseData = try Hr.ResponseData.decode(json)
        p.success(responseData)
      } catch let e as NSError {
        p.failure(AppError.Network(e))
      }
    }
    
    return p.future
  }
}

protocol API {
  func exec<HR: APIRequest>(hr: HR) -> Future<HR.ResponseData, AppError>
}

final class DefaultAPI: API {
  init(config: Config) {}
  
  func exec<HR: APIRequest>(hr: HR) -> Future<HR.ResponseData, AppError> {
    return Alamofire.request(hr.urlRequest).toFuture(HR)
  }
}























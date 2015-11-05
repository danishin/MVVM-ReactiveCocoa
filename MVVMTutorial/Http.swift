//
//  Http.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import ReactiveCocoa

private extension Request {
  func toSignalProducer<HR: HttpRequest>(hr: HR.Type) -> SignalProducer<HR.ResponseData, AppError> {
    return SignalProducer { (sink, _) in
      self.responseJSON { r in
        if let error = r.result.error { fatalError(error.description) }
        guard let json = r.result.value else { fatalError() }
        
        let responseData = try! hr.ResponseData.decode(json)
        
        sendNext(sink, responseData)
        sendCompleted(sink)
      }
    }
  }
}

protocol Http {
  func exec<HR: HttpRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError>
}

struct DefaultHttp: Http {
  let baseURL: String
  
  func exec<HR: HttpRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError> {
    return Alamofire.request(hr.urlRequest).toSignalProducer(hr.dynamicType)
  }
}























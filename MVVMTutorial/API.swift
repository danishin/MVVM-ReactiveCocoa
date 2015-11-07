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
  func toSignalProducer<HR: APIRequest>(Hr: HR.Type) -> SignalProducer<HR.ResponseData, AppError> {
    return SignalProducer { (sink, _) in
      self.responseJSON { r in
        if let error = r.result.error { fatalError(error.description) }
        guard let json = r.result.value else { fatalError() }
        
        let responseData = try! Hr.ResponseData.decode(json)
        
        sendNext(sink, responseData)
        sendCompleted(sink)
      }
    }
  }
}

protocol API {
  func exec<HR: APIRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError>
}

final class DefaultAPI: API {
  init(config: Config) {}
  
  func exec<HR: APIRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError> {
    return Alamofire.request(hr.urlRequest).toSignalProducer(HR)
  }
}























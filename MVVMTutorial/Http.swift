//
//  Http.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import ReactiveCocoa
import SwiftyJSON

private extension Request {
  func toSignalProducer<HR: HttpRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError> {
    return SignalProducer { (sink, _) in
      self.response { (request, response, data, error) -> Void in
//        if let error = error { return sendError(sink, AppError.Network(error)) }
        if let error = error { fatalError(error.description) }
        print(JSON(data: data!))
        guard let data = data, let responseData = hr.parse(SwiftyJSON.JSON(data: data)) else { fatalError() }
        
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
  func exec<HR: HttpRequest>(hr: HR) -> SignalProducer<HR.ResponseData, AppError> {
    return Alamofire.request(hr.urlRequest).toSignalProducer(hr)
  }
}























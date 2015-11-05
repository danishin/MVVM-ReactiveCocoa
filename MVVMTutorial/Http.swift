//
//  Http.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import ReactiveCocoa
import Swiftz
import SwiftyJSON

protocol ResponseType {}

extension SwiftyJSON.JSON: ResponseType {}

protocol HttpRequest {
  typealias Response: ResponseType
  
  var urlRequest: Either<NSError, URLRequestConvertible> { get }
}

extension HttpRequest {
  var urlRequest: Either<NSError, URLRequestConvertible> {
    fatalError()
  }
}

enum Fetch: HttpRequest {
  typealias Response = SwiftyJSON.JSON
  
  case GoogleImages(keyword: String)
  
  private var info: (String, [String: AnyObject]) {
    switch self {
    case let .GoogleImages(keyword): return ("google", ["p": keyword])
    }
  }
  
  var urlRequest: Either<NSError, URLRequestConvertible> {
    let (path, parameters) = self.info
    
    let request = NSMutableURLRequest(URL: NSURL(string: path)!)
    request.HTTPMethod = Alamofire.Method.GET.rawValue
    
    let (r, e) = Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters)
    if let e = e { return Either.Left(e) }
    else { return Either.Right(r) }
  }
}

protocol Http {
  func exec<HR: HttpRequest>(r: HR) -> HR.Response
}

struct DefaultHttp: Http {
  init() {
  }
  
  func exec<HR: HttpRequest>(r: HR) -> HR.Response {
    r.urlRequest
      .fmap(Alamofire.request)
    
    fatalError()
  }
}
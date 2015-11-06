//
//  Request.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import Decodable

protocol HttpRequest {
  typealias ResponseData: Decodable
  
  var method: Alamofire.Method { get }
  var info: (String, [String: AnyObject]) { get }
}

extension HttpRequest {
  var urlRequest: URLRequestConvertible {
    let (path, parameters) = self.info
    
    let request = NSMutableURLRequest(URL: NSURL(string: path)!)
    request.HTTPMethod = self.method.rawValue
    
    switch self.method {
    case .GET, .DELETE:
      let (r, e) = Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters)
      if let _ = e { fatalError() }
      else { return r }
      
    case .POST, .PUT:
      let (r, e) = Alamofire.ParameterEncoding.JSON.encode(request, parameters: parameters)
      if let _ = e { fatalError() }
      else { return r }
      
    default: fatalError()
    }
  }
}

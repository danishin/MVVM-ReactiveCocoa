//
//  GET.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import Decodable

protocol GET: HttpRequest { typealias ResponseData: GETResponseData }
extension GET { var method: Alamofire.Method { return Alamofire.Method.GET } }

protocol GETResponseData: ResponseDataType {}

struct GETRandomUser: GET {
  let keyword: String
  
  var info: (String, [String: AnyObject]) { return ("https://randomuser.me/api", ["gender": keyword]) }
  struct ResponseData: GETResponseData {
    let users: [User]
    let nationality: String
    
    static func decode(j: AnyObject) throws -> ResponseData {
      return try ResponseData(
        users: j => "results",
        nationality: j => "nationality"
      )
    }
  }
}
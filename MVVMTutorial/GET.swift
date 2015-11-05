//
//  GET.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol GET: HttpRequest { typealias ResponseData: GETResponseData }
extension GET { var method: Alamofire.Method { return Alamofire.Method.GET } }

protocol GETResponseData: ResponseDataType {}

struct GETRandomUser: GET {
  let keyword: String
  
  var info: (String, [String: AnyObject]) { return ("https://randomuser.me/api", ["gender": keyword]) }
  
  struct ResponseData: GETResponseData { let username: String; let email: String }
  func parse(j: SwiftyJSON.JSON) -> ResponseData? {
    guard
      let u = j["results"].array?.first?["user"],
      let username = u["username"].string,
      let email = u["email"].string
    else { return nil }
    
    return ResponseData(username: username, email: email)
  }
}

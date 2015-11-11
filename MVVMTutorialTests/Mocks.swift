//
//  Mocks.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import RealmSwift
import BrightFutures

@testable import MVVMTutorial

class MockConfig: Config {
  let BaseURL = "HELLO"
  func RealmConfig(username: String) -> Realm.Configuration {
    return Realm.Configuration(inMemoryIdentifier: "Test:\(username)")
  }
}

class MockAPI: API {
  func exec<HR : APIRequest>(hr: HR) -> Future<HR.ResponseData, AppError> {
    func mock(json: () -> AnyObject) -> Future<HR.ResponseData, AppError> {
      let p = Promise<HR.ResponseData, AppError>()
      do { p.success(try HR.ResponseData.decode(json())) }
      catch let error { p.failure(AppError.Network(error)) }
      return p.future
    }
    
    switch hr {
    case let v as GETRandomUser:
      return mock {
        var j = [String: AnyObject]()
        j["results"] = (0..<v.userNum).map { i in
          ["user": [
            "name": ["first": "user\(i)"],
            "email": "user\(i)@gmail.com",
            "username": "username\(i)",
            "password": "password\(i)",
            "picture": ["medium": "http://image.com/\(i).jpeg"]
            ]
          ]
        }
        j["nationality"] = "KR"
        return j
      }
    default:
      fatalError()
    }
  }
}

private func json(dict: [String: AnyObject]) -> AnyObject {
  return try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
}



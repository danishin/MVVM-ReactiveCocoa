//
//  MVVMTutorialTests.swift
//  MVVMTutorialTests
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveCocoa
import BrightFutures
import Swinject
import Realm
import RealmSwift

@testable import MVVMTutorial

extension MutableProperty {
  func success(name: String?, onNext: Value -> Void) -> Disposable {
    if let name = name {
      return producer.debug(name).startWithNext(onNext)
    } else {
      return producer.startWithNext(onNext)
    }
  }
  
  func success(onNext: Value -> Void) -> Disposable {
    return success(nil, onNext: onNext)
  }
}

extension MutableProperty where Value: CocoaAction {
  func run() -> Disposable {
    return success { $0.execute(nil) }
  }
}

private class MockConfig: Config {
  let BaseURL = "HELLO"
  func RealmConfig(user_id: Int) -> Realm.Configuration {
    fatalError()
  }
}

class MVVMTutorialTests: QuickSpec {
  override func spec() {
    describe("ViewModel") {
      let c = SwinjectStoryboard.defaultContainer
      c.register(Config.self) { _ in MockConfig() }
      
      var vm: ViewModel!
      
      beforeEach {
        vm = c.get(ViewModel.self)
      }
      
      it("works") {
        var isSearching = false
        
        vm.userNum.value = 1
        vm.gender.value = "female"
        
        vm.search.run()
        vm.isSearching.success("isSearching") { isSearching = $0 }
        
        expect(isSearching).toEventually(equal(true))
        expect(isSearching).toEventually(equal(false), timeout: 5)
      }
    }
  }
}

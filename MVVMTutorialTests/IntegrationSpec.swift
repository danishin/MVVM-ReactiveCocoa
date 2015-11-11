//
//  IntegrationSpec.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Quick
import Nimble
import Swinject

@testable import MVVMTutorial

protocol Testable {
  typealias VM: ViewModel
  static func test(vm: VM)
}
extension Testable {
  static func exec(vm: VM) { describe(String(self.dynamicType)) { it("") { test(vm) } } }
}

class IntegrationSpec: QuickSpec {
  let c = SwinjectStoryboard.defaultContainer
  
  override func spec() {
    c.register(Config.self) { _ in MockConfig() }
    c.register(API.self) { _ in MockAPI() }
    
    LoginViewModelSpec.exec(c.get(LoginViewModel))
    UsersViewModelSpec.exec(c.get(UsersViewModel))
  }
}
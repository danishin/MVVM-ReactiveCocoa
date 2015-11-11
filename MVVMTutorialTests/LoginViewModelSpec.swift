//
//  LoginViewModelSpec.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Quick
import Nimble

@testable import MVVMTutorial

class LoginViewModelSpec {
  static func test(vm: LoginViewModel) {
    describe("LoginViewModel") {
      it("") {
        vm.loggedIn === false
        vm.loginEnabled === false
        
        vm.username.value = "Daniel1104"
        vm.password.value = "password"
        
        vm.loginEnabled === true
        
        vm.login.run()
        
        vm.loggedIn &=== true
      }
    }
  }
}
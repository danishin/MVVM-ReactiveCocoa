//
//  MVVMTutorialTests.swift
//  MVVMTutorialTests
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Quick
import Nimble

@testable import MVVMTutorial

final class UsersViewModelSpec: Testable {
  static func test(vm: UsersViewModel) {
    let userNum = 1
    let gender = "female"
    
    vm.userNum.value = userNum
    vm.gender.value = gender
    
    vm.search.run()
    
    vm.isSearching &=== true
    vm.isSearching &=== false
    vm.usersCount === userNum
  }
}


//
//  TestHelpers.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa

infix operator === {}
func === <A: Equatable>(l: MutableProperty<A>, r: A?) {
  expect(l.value).to(equal(r))
}

func === <A: Equatable>(l: A?, r: A?) {
  expect(l).to(equal(r))
}

infix operator &=== {}
func &=== <A: Equatable>(l: MutableProperty<A>, r: A?) {
  var a: A? = nil
  l.success { a = $0 }
  expect(a).toEventually(equal(r))
}

func &=== <A: Equatable>(l: MutableProperty<A>, r: (A?, Int)) {
  let (ra, timeout) = r
  
  var a: A? = nil
  l.success { a = $0 }
  expect(a).toEventually(equal(ra), timeout: NSTimeInterval(timeout))
}

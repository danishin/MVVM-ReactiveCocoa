//
//  Dependency.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import Swinject

extension SwinjectStoryboard {
  class func setup() {
    let c = defaultContainer
    
    /* Configuration */
    c.register(Config.self) { _ in DefaultConfig() }.inObjectScope(.Container)
    
    /* Model */
    c.register(LocalUser.self) { _ in LocalUser() }.inObjectScope(.Container)
    c.register(API.self) { r in DefaultAPI(config: r.get(Config.self)) }.inObjectScope(.Container)
    c.register(DB.self) { r in RealmDB(config: r.get(Config.self), localUser: r.get(LocalUser.self)) }.inObjectScope(.Container)
    
    /* ViewModel */
    c.register(LoginViewModel.self) { r in LoginViewModel(localUser: r.get(LocalUser.self)) }
    c.register(SearchUsersViewModel.self) { r in SearchUsersViewModel(api: r.get(API.self), db: r.get(DB.self)) }.inObjectScope(.Container)
    
    /* View */
    c.registerForStoryboard(LoginViewController.self) { r, vc in
      vc.vm = r.get(LoginViewModel.self)
    }
    c.registerForStoryboard(SearchUsersViewController.self) { r, vc in
      vc.vm = r.get(SearchUsersViewModel.self)
    }
  }
}

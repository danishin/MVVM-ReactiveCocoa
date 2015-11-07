//
//  AppDelegate.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import Swinject

private extension Resolvable {
  func get<Service>(serviceType: Service.Type) -> Service {
    guard let service = resolve(serviceType) else { fatalError("DI Error: Failed to resolve \(serviceType)") }
    return service
  }
  
  func get<Service, Arg1>(serviceType: Service.Type, arg1: Arg1) -> Service {
    guard let service = resolve(serviceType, arg1: arg1) else { fatalError("DI Error: Failed to resolve \(serviceType) with \(arg1)") }
    return service
  }
}

extension SwinjectStoryboard {
  class func setup() {
    let c = defaultContainer
    
    /* Configuration */
    c.register(Config.self) { _ in DefaultConfig() }.inObjectScope(.Container)
    
    /* Model */
    c.register(API.self) { r, a1 in DefaultAPI(config: a1) }.inObjectScope(.Container)
    
    /* ViewModel */
    c.register(ViewModel.self) { r in ViewModel(api: r.get(API.self, arg1: r.get(Config.self))) }.inObjectScope(.Container)
    
    /* View */
    c.registerForStoryboard(ViewController.self) { r, vc in
      vc.vm = r.get(ViewModel.self)
    }
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}


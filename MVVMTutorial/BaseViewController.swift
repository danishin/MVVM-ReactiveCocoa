//
//  BaseViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit

protocol ViewModel {}

class BaseViewController: UIViewController {
  func bind() {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    print("Current ViewController: \(self.dynamicType)")
  }
  
  func push<VC: BaseViewController>(vcType: VC.Type, decorate: VC -> VC) {
    let vcName = String(vcType)
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(vcName) as! VC
    self.navigationController!.pushViewController(decorate(vc), animated: true)
  }
  
  func pop() {
    self.navigationController!.popViewControllerAnimated(true)
  }
}
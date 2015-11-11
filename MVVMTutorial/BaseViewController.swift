//
//  BaseViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    print("Current ViewController: \(self.dynamicType)")
  }
}
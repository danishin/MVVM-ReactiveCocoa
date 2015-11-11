//
//  LoginViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Rex

class LoginViewController: BaseViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  var vm: LoginViewModel!
  
  override func bind() {
    vm.username <~ usernameTextField.textSignalProducer
    vm.password <~ passwordTextField.textSignalProducer
    
    loginButton.rex_pressed <~ vm.login.debug()
    
    vm.loggedIn.producer.filter{ $0 }.startWithNext { [unowned self] _ in
      self.usernameTextField.text = ""
      self.passwordTextField.text = ""
      self.performSegueWithIdentifier("ShowSearchUsers", sender: self)
    }
  }
}

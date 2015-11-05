//
//  ViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ViewController: UIViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  var vm: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm.text <~ textField.toSignalProducer { $0 as! String }
    searchButton =>> vm.searchImage
    usernameLabel.rac_text <~ vm.username
    emailLabel.rac_text <~ vm.email
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


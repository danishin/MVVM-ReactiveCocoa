//
//  ViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Rex
import Result

class ViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  var vm: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Bind From Button to Action
    searchButton =>> vm.searchImage
    
    // Bind From UI to VM
    vm.text <~ textField.toSignalProducer { $0 as! String }
    
    // Bind From VM to UI
    titleLabel.rex_text <~ vm.title
    
    usernameLabel.rex_text <~ vm.username
    
    emailLabel.rex_text <~ vm.email
    
    searchButton.rex_pressed.value = vm.searchImage
//    searchButton.rex_pressed <~ vm.isIdle.producer.map { $0 ? 1.0 : 0.3 }
    
    // TODO: Get cell_vm from vm and simply populate it to each cell in cellForRowAtIndexPath.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


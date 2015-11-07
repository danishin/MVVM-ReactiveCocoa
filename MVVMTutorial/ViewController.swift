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

final class ViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var tableView: UITableView!
  
  var vm: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let textSignal = textField.rac_textSignal().toSignalProducer().ignoreError().map { $0 as! String }
    
    // Bind From Button to Action
    searchButton.rex_pressed.value = CocoaAction(vm.searchImage, input: titleLabel.text ?? "")
    
    
    let searchButtonPressed = searchButton.rex_pressed.producer.flatMap(.Latest) { $0.rex_executingProducer }
    searchButton.rex_title <~ searchButtonPressed.map { $0 ? "Searching..." : "Search" }
    
    // TODO: Use filterMap with new rex version
    DynamicProperty(object: textField, keyPath: "text") <~ searchButtonPressed.filter { $0 }.map { _ in "" }
    
    searchButton.rex_enabled <~ SignalProducer(values: [
      textSignal.map { !$0.isEmpty },
      searchButtonPressed.map { _ in false }
    ]).flatten(.Merge)
    
    
    titleLabel.rex_text <~ vm.title
    
    vm.cell_models.producer.on(next: { _ in self.tableView.reloadData() }).start()
    
    // TODO: Get cell_vm from vm and simply populate it to each cell in cellForRowAtIndexPath.
    
    // TODO: Separate LoginViewModel and UserViewModel.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return vm.cell_models.value.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
    cell.model = vm.cell_models.value[indexPath.row]
    
    return cell
  }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
  
}




// stateless core, stateful shell
// Keep core domain logic in completely immutable value types
// Add stateful shell objects with mutable references to the immutable data
class LoginViewModel {
  var username: String?
  var password: String?
  
  func login() -> UserViewModel? { return nil }
}

class UserViewModel {
  var loggedInUser: User?
}
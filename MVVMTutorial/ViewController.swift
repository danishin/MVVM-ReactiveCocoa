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
  @IBOutlet weak var userNumLabel: UILabel!
  @IBOutlet weak var userNumSlider: UISlider!
  @IBOutlet weak var genderSegmentControl: UISegmentedControl!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  
  @IBOutlet weak var tableView: UITableView!
  
  var vm: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userNumSlided = userNumSlider.rex_controlEvents(.ValueChanged).map { Int(($0 as! UISlider).value) }
    let genderSeleted = genderSegmentControl.rex_controlEvents(.ValueChanged).map { $0 as! UISegmentedControl }.map { s -> String? in
      let i = s.selectedSegmentIndex
      if i == -1 { return nil }
      return s.titleForSegmentAtIndex(i)
    }
    let searchButtonExecuting = searchButton.rex_pressed.producer.flatMap(.Latest) { $0.rex_executingProducer }.skipRepeats()
    let searchButtonTapped = searchButtonExecuting.filter { $0 }.map { _ in () }

    /* TitleLabel */
    titleLabel.rex_text <~ vm.title
    
    /* UserNumLabel */
    userNumLabel.rex_text <~ SignalProducer(values: [
      userNumSlided.map { $0 },
      searchButtonTapped.map { 0 }
    ]).flatten(.Merge).map { String($0) }
    
    /* UserNumSlider */
    // TODO: Use filterMap with new rex version
    userNumSlider.rex_enabled <~ searchButtonExecuting.map { !$0 }
    userNumSlider.rex_stringProperty("value") <~ searchButtonTapped.map { "" }
    
    /* GenderSegmentControl */
    DynamicProperty(object: genderSegmentControl, keyPath: "selectedSegmentIndex") <~ searchButtonTapped.map { -1 }
    
    /* SearchButton */
    searchButton.rex_pressed <~ combineLatest(userNumSlided, genderSeleted).map { [unowned self] in CocoaAction(self.vm.searchImage, input: ($0, $1!)) }
    searchButton.rex_title <~ searchButtonExecuting.map { $0 ? "Searching..." : "Search" }
    searchButton.rex_enabled <~ SignalProducer(values: [
      combineLatest(userNumSlided.map { $0 != 0 }, genderSeleted.map { $0 != nil }).map { $0 && $1 },
      searchButtonTapped.map { false }
    ]).flatten(.Merge)

    
    vm.cell_models.producer.on(next: { [weak self] _ in self?.tableView.reloadData() }).start()
    
    // TODO: Separate LoginViewModel and UserViewModel.
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
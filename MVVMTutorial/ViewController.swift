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

final class ViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var userNumLabel: UILabel!
  @IBOutlet weak var userNumSlider: UISlider!
  @IBOutlet weak var genderSegmentControl: UISegmentedControl!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  
  var vm: ViewModel!
  
  // FIXME: Even all logics concerning simple `enabled`-like state needs to be delegated to viewmodel. View must be completely dumb.
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm.userNum <~ userNumSlider.rex_controlEvents(.ValueChanged).map { Int(($0 as! UISlider).value) }
    vm.gender <~ genderSegmentControl.rex_controlEvents(.ValueChanged).map { $0 as! UISegmentedControl }.filterMap { s in
      Optional(s.selectedSegmentIndex)
        .flatMap { $0 == -1 ? nil : $0 }
        .flatMap { s.titleForSegmentAtIndex($0) }
    }
    
    /* TitleLabel */
    titleLabel.rex_text <~ vm.title
    
    /* UserNumLabel */
    userNumLabel.rex_text <~ vm.userNum.producer.map { String($0) }
    
    /* UserNumSlider */
    userNumSlider.rex_enabled <~ vm.isSearching.producer.map { !$0 }
    userNumSlider.rex_stringProperty("value") <~ vm.userNum.producer.filterMap { $0 == 0 ? "" : nil }
    
    /* GenderSegmentControl */
    // NB: Choose between DynamicProperty or rex_valueForProperty for UIControls whose value is not String
    DynamicProperty(object: genderSegmentControl, keyPath: "selectedSegmentIndex") <~ vm.gender.producer.filterMap { $0 == "" ? -1 : nil }
    
    /* SearchButton */
    searchButton.rex_pressed <~ vm.search
    searchButton.rex_title <~ vm.isSearching.producer.map { $0 ? "Searching..." : "Search" }
    
    /* ActivityIndicator */
    vm.isSearching.producer.startWithNext { [weak self] in $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating() }

    /* TableView */
    vm.cell_models.producer.startWithNext { [weak self] _ in self?.tableView.reloadData() }
    
    // TODO: Separate LoginViewModel and UserViewModel.
    
    // TODO: You can declare relationship between child viewcontroller and parent viewcontroller by binding inside viewmodel from one of its property to newly created child viewmodel's property
    // TODO: This kind of declaring relationship between viewcontrollers by using viewmodel can fully replace ugly delegate patterns.
    
    // TODO: With regards to simple relationship like presentingVC and alertVC and the like can simply share the same viewmodel to further emphasize their tight relationship.
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
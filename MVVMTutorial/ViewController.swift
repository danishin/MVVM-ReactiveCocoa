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
    
    
    
    let userNumSlided = userNumSlider.rex_controlEvents(.ValueChanged).map { Int(($0 as! UISlider).value) }
    let genderSeleted = genderSegmentControl.rex_controlEvents(.ValueChanged).map { $0 as! UISegmentedControl }.map { s in
      Optional(s.selectedSegmentIndex)
        .flatMap { $0 == -1 ? nil : $0 }
        .flatMap { s.titleForSegmentAtIndex($0) }
    }
    let searchStarted = vm.isSearching.producer.filterMap { $0 ? () : nil }
    
    /* TitleLabel */
    titleLabel.rex_text <~ vm.title
    
    /* UserNumLabel */
    userNumLabel.rex_text <~ SignalProducer(values: [
      userNumSlided,
      searchStarted.map { 0 }
    ]).flatten(.Merge).map { String($0) }
    
    /* UserNumSlider */
    userNumSlider.rex_enabled <~ vm.isSearching.producer.map { !$0 }
    userNumSlider.rex_stringProperty("value") <~ searchStarted.map { "" }
    
    /* GenderSegmentControl */
    // NB: Choose between DynamicProperty or rex_valueForProperty for UIControls whose value is not String
    DynamicProperty(object: genderSegmentControl, keyPath: "selectedSegmentIndex") <~ searchStarted.map { -1 }
    
    /* SearchButton */
    searchButton.rex_pressed <~ combineLatest(userNumSlided, genderSeleted).map { [unowned self] in CocoaAction(self.vm.search, input: ($0, $1!)) }
    searchButton.rex_title <~ vm.isSearching.producer.map { $0 ? "Searching..." : "Search" }
    searchButton.rex_enabled <~ SignalProducer(values: [
      combineLatest(userNumSlided.map { $0 != 0 }, genderSeleted.map { $0 != nil }).map { $0 && $1 },
      vm.isSearching.producer.map { _ in false }
    ]).flatten(.Merge)
    
    /* ActivityIndicator */
    vm.isSearching.producer.startWithNext { [weak self] in $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating() }

    /* TableView */
    vm.cell_models.producer.startWithNext { [weak self] _ in self?.tableView.reloadData() }
    
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
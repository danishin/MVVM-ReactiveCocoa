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

final class UsersViewController: BaseViewController {
  @IBOutlet weak var titleNavigationItem: UINavigationItem!
  @IBOutlet weak var userNumLabel: UILabel!
  @IBOutlet weak var userNumSlider: UISlider!
  @IBOutlet weak var genderSegmentControl: UISegmentedControl!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  
  var vm: UsersViewModel!
  
  override func bind() {
    vm.userNum <~ userNumSlider.rex_controlEvents(.ValueChanged).map { Int(($0 as! UISlider).value) }
    vm.gender <~ genderSegmentControl.rex_controlEvents(.ValueChanged).map { $0 as! UISegmentedControl }.filterMap { s in
      Optional(s.selectedSegmentIndex).flatMap { $0 == -1 ? nil : s.titleForSegmentAtIndex($0) }
    }
    
    /* TitleLabel */
    titleNavigationItem.rex_stringProperty("title") <~ vm.title
    
    /* UserNumLabel */
    userNumLabel.rex_text <~ vm.userNum.producer.map { String($0) }
    
    /* UserNumSlider */
    userNumSlider.rex_enabled <~ vm.isSearching.producer.map { !$0 }
    userNumSlider.property("value") <~ vm.userNum.producer.filterMap { $0 == 0 ? "" : nil }
    
    /* GenderSegmentControl */
    // NB: Choose between DynamicProperty or rex_valueForProperty for UIControls whose value is not String
    genderSegmentControl.property("selectedSegmentIndex") <~ vm.gender.producer.filterMap { $0.isEmpty ? -1 : nil }
    
    /* SearchButton */
    searchButton.rex_pressed <~ vm.search
    searchButton.rex_title <~ vm.buttonTitle
    
    /* ActivityIndicator */
    vm.isSearching.producer.startWithNext { [weak self] in $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating() }
    
    /* TableView */
    vm.reloadSignal.observeNext { [weak self] in self?.tableView.reloadData() }
  }
}

// MARK: UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return vm.usersCount
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
    cell.user = vm.userAt(indexPath)
    return cell
  }
}

// MARK: UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    push(EditCommentViewController.self) { [unowned self] in
      $0.vm = self.vm.editCommentVM(indexPath)
      return $0
    }
  }
}








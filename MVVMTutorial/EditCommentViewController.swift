//
//  CommentViewController.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-11.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Rex

class EditCommentViewController: BaseViewController {
  @IBOutlet weak var commentTextView: UITextField!
  @IBOutlet weak var saveBarButton: UIBarButtonItem!
  
  var vm: EditCommentViewModel!
  
  override func bind() {
    vm.comment <~ commentTextView.textSignalProducer
    
    saveBarButton.rex_action <~ vm.save
    
    vm.doneSignal.observeCompleted { [weak self] in self?.pop() }
  }
}


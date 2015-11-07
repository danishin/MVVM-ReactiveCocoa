//
//  ViewModel.swift
//  MVVMTutorial
//
//  Created by Daniel Shin on 2015-11-05.
//  Copyright © 2015 Daniel Shin. All rights reserved.
//

import ReactiveCocoa
import Rex
import Swinject

final class ViewModel {
  let title: ConstantProperty<String>
  
  var searchImage: Action<String, Void, AppError>!
  
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  init(http: Http, titleName: String) {
    title = ConstantProperty(titleName)
    
    searchImage = Action {
      http.exec(GETRandomUser(keyword: $0))
        .print()
        .map { $0.users.map { UserCellModel.from(user: $0) } }
        .on(next: { self.cell_models.value += $0 })
        .map { _ in () }
      }
  }
}
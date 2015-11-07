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
  var searchImage: Action<(Int, String), Void, AppError>!
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  init(http: Http, titleName: String) {
    title = ConstantProperty(titleName)
    
    searchImage = Action {
      http.exec(GETRandomUser(userNum: $0, gender: $1))
        .print()
        .map { $0.users.map { UserCellModel.from(user: $0) } }
        .on(next: { [weak self] in self?.cell_models.value += $0 })
        .map { _ in () }
      }
  }
}
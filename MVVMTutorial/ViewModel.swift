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
  let title = MutableProperty("")
  var searchImage: Action<(Int, String), Void, AppError>!
  let cell_models = MutableProperty<[UserCellModel]>([])
  
  init(api: API) {
    searchImage = Action {
      api.exec(GETRandomUser(userNum: $0, gender: $1))
        .map { ($0.nationality, $0.users.map { UserCellModel.from(user: $0) }) }
        .on(next: { [weak self] in
          self?.title.value = $0
          self?.cell_models.value += $1 }
        )
        .map { _ in () }
      }
  }
}
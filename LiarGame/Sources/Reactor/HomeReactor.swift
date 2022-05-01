//
//  HomeReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class HomeReactor: Reactor {
  enum Action {
    case updateMode(GameMode)
  }

  enum Mutation {
    case setMode(GameMode)
  }

  struct State {
    var mode: GameMode?
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateMode(let mode):
      return Observable.just(Mutation.setMode(mode))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setMode(let mode):
      var newState = state
      newState.mode = mode
      return newState
    }
  }
}

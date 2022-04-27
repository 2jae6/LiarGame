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
    case let .updateMode(mode):
      return Observable.just(Mutation.setMode(mode))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case let .setMode(mode):
      var newState = state
      newState.mode = mode
      return newState
    }
  }
}

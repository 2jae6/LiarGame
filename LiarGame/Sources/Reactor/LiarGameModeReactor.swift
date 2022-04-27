//
//  LiarGameModeReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class LiarGameModeReactor: Reactor {
  enum Action {
    case selectMode(LiarGameMode?)
  }

  enum Mutation {
    case setMode(LiarGameMode?)
  }

  struct State {
    var mode: LiarGameMode?
  }

  let initialState: State = .init()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .selectMode(mode):
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

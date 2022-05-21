//
//  LiarGameModeReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import Foundation

import Pure
import ReactorKit
import RxCocoa
import RxSwift

final class LiarGameModeReactor: Reactor, FactoryModule {
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
  
  // MARK: Initialize
  
  init(dependency _: Void, payload _: Void) { }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectMode(let mode):
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

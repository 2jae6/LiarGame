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

public final class LiarGameModeReactor: Reactor, FactoryModule {
  public enum Action {
    case selectMode(LiarGameMode?)
  }

  public enum Mutation {
    case setMode(LiarGameMode?)
  }

  public struct State {
    var mode: LiarGameMode?
  }

  public let initialState: State

  // MARK: Initialize

  public init(dependency _: Void, payload _: Void) {
    initialState = .init()
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectMode(let mode):
      return Observable.just(Mutation.setMode(mode))
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setMode(let mode):
      var newState = state
      newState.mode = mode
      return newState
    }
  }
}

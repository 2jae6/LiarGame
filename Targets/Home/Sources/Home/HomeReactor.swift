//
//  HomeReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import Foundation
import Pure
import ReactorKit
import RxCocoa
import RxSwift

public final class HomeReactor: Reactor, FactoryModule {
  public enum Action {
    case updateMode(GameMode)
  }

  public enum Mutation {
    case setMode(GameMode)
  }

  public struct State {
    var mode: GameMode?
  }

  public let initialState: State

  // MARK: Initialize

  public init(dependency _: Void, payload _: Void) {
    initialState = .init()
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateMode(let mode):
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

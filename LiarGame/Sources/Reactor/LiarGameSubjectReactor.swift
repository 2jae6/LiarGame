//
//  LiarGameSubjectReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import Foundation
import Pure
import ReactorKit
import RxCocoa
import RxSwift

final class LiarGameSubjectReactor: Reactor, FactoryModule {
  enum Action {
    case selectSubject(LiarGameSubject)
  }

  enum Mutation {
    case setSubject(LiarGameSubject)
  }

  struct State {
    var selectedSubject: LiarGameSubject?
  }

  // MARK: Initialize
  
  init(dependency: Void, payload: Void) { }
  
  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectSubject(let subject):
      return Observable.just(Mutation.setSubject(subject))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setSubject(let subject):
      var newState = state
      newState.selectedSubject = subject
      return newState
    }
  }
}

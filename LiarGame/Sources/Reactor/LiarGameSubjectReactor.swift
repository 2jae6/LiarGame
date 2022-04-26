//
//  LiarGameSubjectReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit


final class LiarGameSubjectReactor: Reactor{
    enum Action {
        case selectSubject(LiarGameSubject)
    }
    enum Mutation {
        case setSubject(LiarGameSubject)
    }
    struct State {
        var selectedSubject: LiarGameSubject?
    }

    var initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectSubject(subject):
            return Observable.just(Mutation.setSubject(subject))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setSubject(subject):
            var newState = state
            newState.selectedSubject = subject
            return newState
        }
    }

}

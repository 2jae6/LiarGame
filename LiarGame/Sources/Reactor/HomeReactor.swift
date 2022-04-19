//
//  HomeReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa


final class HomeReactor: Reactor{
    enum Action{
        case updateMode(String?)
    }
    enum Mutation{
        case setMode(String?)
    }
    struct State{
        var mode: String?
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

//
//  LiarGameReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/26.
//

import Foundation
import RxSwift
import Then
import ReactorKit

final class LiarGameReactor: Reactor{
    
    enum Action{
        case tappedCurtain
        case tappedLiar
    }
    
    enum Mutation{
        case setCurtain(Bool)
        case setLiar(Bool)
    }
    
    struct State{
        var curtainTapped: Bool?
        var liarTapped: Bool?
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tappedCurtain:
            return Observable.just(Mutation.setCurtain(true))
        case .tappedLiar:
            return Observable.just(Mutation.setLiar(true))
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setCurtain(tapped):
            var newState = state
            newState.curtainTapped = tapped
            return newState
            
        case let .setLiar(tapped):
            var newState = state
            newState.liarTapped = tapped
            return newState
        }
    }
    
}

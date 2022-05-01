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
    case initWord(Int, LiarGameSubject, LiarGameMode)
    case tappedCurtain
    case tappedLiar
  }
  
  enum Mutation{
    case setWord
    case setCurtain(Bool)
    case setLiar(Bool)
    case setLiarText(String)
  }
  
  struct State{
    var curtainTapped: Bool?
    var liarTapped: Bool?
    var liarSetText: String?
  }
  
  var initialState: State = State()
  var gameData = [LiarGameModel]()
  var turn: Int = 0
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .initWord(memberCount, selectSubject, mode):
      self.setupLiarWord(memberCount: memberCount, subject: selectSubject, mode: mode)
      return Observable.just(.setWord)
      
    case .tappedCurtain:
      return Observable.just(Mutation.setLiarText(self.gameData[self.turn].word))
      
    case .tappedLiar:
      self.turn += 1
      return Observable.just(Mutation.setLiar(true))
    }
  }
  
  
  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setWord:
      return state
    case let .setCurtain(tapped):
      var newState = state
      newState.curtainTapped = tapped
      return newState
      
    case let .setLiar(tapped):
      var newState = state
      newState.liarTapped = tapped
      return newState
    case let .setLiarText(word):
      var newState = state
      newState.liarSetText = word
      return newState
    }
  }
  
}
extension LiarGameReactor{
  
  private func setupLiarWord(memberCount: Int, subject: LiarGameSubject, mode: LiarGameMode){
    let wordList = LiarGameList()
    let randomNumber = Int(arc4random()) % wordList.list.count
    let selectedWord = wordList.list[randomNumber]
    
    for _ in 0 ..< memberCount - 1{
      self.gameData.append(selectedWord)
    }
    
    let insertRandomNumber = Int(arc4random()) % memberCount
    self.gameData.insert((LiarGameModel(word: "라이어입니다.", subject: .job)), at: insertRandomNumber)
  }


  
}

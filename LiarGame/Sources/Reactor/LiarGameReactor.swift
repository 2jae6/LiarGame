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
    case initWord
    case tappedCurtain
    case tappedLiar
  }
  
  enum Mutation{
    case initWord
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
    case .initWord:
      self.setupLiarWord(memberCount: 3, subject: .job)
      return Observable.just(.initWord)
      
    case .tappedCurtain:
      self.turn += 1
      
      return Observable.just(Mutation.setLiarText(self.gameData[turn].word))
                             
    case .tappedLiar:
      return Observable.just(Mutation.setLiarText("돼지"))
    }
  }
  
  
  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .initWord:
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
  
  private func setupLiarWord(memberCount: Int, subject: LiarGameSubject){
    let wordList = LiarGameList()
    let randomNumber = Int(arc4random()) % wordList.list.count
    let selectedWord = wordList.list[randomNumber]
    
    for i in 0 ..< 3{
      self.gameData.append(selectedWord)
    }
    
    print(selectedWord)
  }
  
  private func shuffleWord(){
    let randomNumber = Int(arc4random())
  }
  
}

//
//  LiarGameReactor.swift
//  LiarGame
//
//  Created by Jay on 2022/04/26.
//

import Foundation
import Pure
import ReactorKit
import RxSwift
import Then

final class LiarGameReactor: Reactor, FactoryModule {
  enum Action {
    case initWord(Int, LiarGameSubject, LiarGameMode)
    case tappedCurtain
    case tappedLiar
  }

  enum Mutation {
    case setWord
    case setCurtain(Bool)
    case setLiar(Bool)
    case setLiarText(String)
  }

  struct State {
    var curtainTapped: Bool?
    var liarTapped: Bool?
    var liarSetText: String?
  }

  // MARK: Properties
  
  var initialState = State()
  var gameData = [LiarGameModel]()
  var turn = 0
  
  // MARK: Initialize
  
  init(dependency _: Void, payload _: Void) { }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initWord(let memberCount, let selectSubject, let mode):
      setupLiarWord(memberCount: memberCount, subject: selectSubject, mode: mode)
      return Observable.just(.setWord)

    case .tappedCurtain:
      return Observable.just(Mutation.setLiarText(gameData[turn].word))

    case .tappedLiar:
      turn += 1
      return Observable.just(Mutation.setLiar(true))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .setWord:
      return state
    case .setCurtain(let tapped):
      var newState = state
      newState.curtainTapped = tapped
      return newState

    case .setLiar(let tapped):
      var newState = state
      newState.liarTapped = tapped
      return newState
    case .setLiarText(let word):
      var newState = state
      newState.liarSetText = word
      return newState
    }
  }

}

extension LiarGameReactor {

  private func setupLiarWord(memberCount: Int, subject: LiarGameSubject, mode: LiarGameMode) {
    var wordList = LiarGameList()
    wordList.list = wordList.list.filter { $0.subject == subject }

    let randomNumber = Int(arc4random()) % wordList.list.count
    let selectedWord = wordList.list[randomNumber]

    for _ in 0 ..< memberCount - 1 {
      gameData.append(selectedWord)
    }

    if mode == .normal {
      let insertRandomNumber = Int(arc4random()) % memberCount
      gameData.insert(LiarGameModel(word: "라이어입니다.", subject: subject), at: insertRandomNumber)
    } else {
      while true {
        let stupidRandomNumber = Int(arc4random()) % wordList.list.count
        if selectedWord.word != wordList.list[stupidRandomNumber].word {
          gameData.insert(LiarGameModel(word: wordList.list[stupidRandomNumber].word, subject: subject), at: stupidRandomNumber)
          break
        }
      }
    }

  }

}

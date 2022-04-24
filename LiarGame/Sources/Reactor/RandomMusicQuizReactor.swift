//
//  RandomMusicQuizReactor.swift
//  LiarGame
//
//  Created by JK on 2022/04/21.
//

import Foundation
import ReactorKit

final class RandomMusicQuizReactor: Reactor {
  init(repository: RandomMusicRepository) {
    self.repository = repository
  }
  
  var initialState = State()
  private let repository: RandomMusicRepository
  
  enum PlaySeconds: Int {
    case three = 3
    case five = 5
    case ten = 10
  }
  
  enum Action {
    case updateMusicList
    case playMusic(second: PlaySeconds)
    case didPlayButtonTapped
    case didStopButtonTapped
    case didAnswerButtonTapped
    case shuffle
  }
  
  enum Mutation {
    case updatePlayingState(Bool)
    case updateCurrentVersion(String)
    case updateCurrentMusic(Music)
    case updateAnswer((String, String)?)
    case updateLoading(Bool)
    case updateMusicList([Music])
  }
  
  struct State {
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var currentVersion: String = ""
    var answer: (title: String, artist: String)?
    var currentMusic: Music?
    // music List 가 관리되어야 할 상태에 포함되는지 고려해야 함.
    var musicList: [Music] = []
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateMusicList:
      return repository.getNewestVersion()
        .asObservable()
        .map { Mutation.updateMusicList($0) }
      
    case let .playMusic(second):
      return .concat([
        .just(.updatePlayingState(true)),
        .just(.updatePlayingState(false))
        .timeout(.seconds(second.rawValue), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
      ])
      
    case .didPlayButtonTapped:
      return .just(.updatePlayingState(true))
    case .didStopButtonTapped:
      return .just(.updatePlayingState(false))
      
    case .didAnswerButtonTapped:
      return .just(.updateAnswer(currentAnswer()))
      
    case .shuffle:
      return .just(.updateCurrentMusic(shuffleMusic()))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updatePlayingState(boolean):
      state.isPlaying = boolean
    case let .updateCurrentVersion(version):
      state.currentVersion = version
    case let .updateCurrentMusic(music):
      state.currentMusic = music
    case let .updateAnswer(info):
      state.answer = info
    case let .updateLoading(boolean):
      state.isLoading = boolean
    case let .updateMusicList(list):
      state.musicList = list
    }
    return state
  }
  
  private func currentAnswer() -> (title: String, artist: String)? {
    if let currentMusic = currentState.currentMusic {
      return (title: currentMusic.title, artist: currentMusic.artist)
    } else {
      return nil
    }
  }
  
  private func shuffleMusic() -> Music {
    let size = currentState.musicList.count
    let randomNumber: Int = Int(arc4random()) % size
    
    return currentState.musicList[randomNumber]
  }
}

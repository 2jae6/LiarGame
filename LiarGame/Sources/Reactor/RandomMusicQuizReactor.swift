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
  
  var scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "random.music.quiz")
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
    case didPlayToggleButtonTapped
    case didAnswerButtonTapped
    case shuffle
    case playerReady
    case needCurrentVersion
  }
  
  enum Mutation {
    case updatePlayingState(Bool)
    case updateCurrentVersion(String)
    case updateCurrentMusic(Music?)
    case updateAnswer((String, String)?)
    case updateLoading(Bool)
    case ignore
  }
  
  struct State {
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var currentVersion: String = ""
    var answer: (title: String, artist: String)?
    var currentMusic: Music?
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateMusicList:
      return .concat([
        .just(.updateLoading(true)),
        .just(.updatePlayingState(false)),
        .just(.updateAnswer(nil)),
        repository.getNewestVersion()
          .asObservable()
          .map { _ in Mutation.ignore },
        .just(.updateCurrentMusic(shuffleMusic())),
        .just(.updateCurrentVersion(repository.currentVersion))
      ])
      .timeout(.seconds(10), other: Observable.just(Mutation.updateLoading(false)), scheduler: scheduler)
      
    case let .playMusic(second):
      return .concat([
        .just(.updatePlayingState(true)),
        .just(.updatePlayingState(false))
        .delay(.seconds(second.rawValue), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
      ])
      
    case .didPlayToggleButtonTapped:
      return .just(.updatePlayingState(!currentState.isPlaying))
      
    case .didAnswerButtonTapped:
      return .just(.updateAnswer(currentAnswer()))
      
    case .shuffle:
      return .concat(
        .just(.updateLoading(true)),
        .just(.updatePlayingState(false)),
        .just(.updateAnswer(nil)),
        .just(.updateCurrentMusic(shuffleMusic()))
      )
      .timeout(.seconds(10), other: Observable.just(Mutation.updateLoading(false)), scheduler: scheduler)
      
    case .playerReady:
      return .just(.updateLoading(false))
      
    case .needCurrentVersion:
      return .just(.updateCurrentVersion(repository.currentVersion))
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
    case .ignore: break
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
  
  private func shuffleMusic() -> Music? {
    guard repository.musicList.count > 0 else { return nil }
    let size = repository.musicList.count
    let randomNumber: Int = Int(arc4random()) % size
    
    return repository.musicList[randomNumber]
  }
}

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

  private var disposeBag = DisposeBag()

  var scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "random.music.quiz")
  var initialState = State()
  private let repository: RandomMusicRepository
  private var playerState: PlayerState = .unknwon
  private var second: PlaySecond?

  enum PlaySecond: Int {
    case three = 3
    case five = 5
    case ten = 10
  }

  enum PlayerState {
    /// 비디오 로드 후 대기 중
    case pending
    /// 비디오 로드 완료
    case ready
    /// 비디오 재생 시 버퍼링
    case buffering
    /// 비디오 재생 중
    case playing
    /// 재생정지(stopVideo) 호출 시 cued
    case cued
    case unknwon
  }

  enum Action {
    case updateMusicList
    case playMusicButtonTapped(second: PlaySecond)
    case didPlayToggleButtonTapped
    case didAnswerButtonTapped
    case shuffle
    case playerState(PlayerState)
    case needCurrentVersion
  }

  enum Mutation {
    case updatePlayStopState(Bool)
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
      guard playerState != .pending else { return .empty() }
      playerState = .pending
      return .concat([
        .just(.updateLoading(true)),
        .just(.updatePlayStopState(false)),
        .just(.updateAnswer(nil)),
        repository.getNewestVersion()
          .asObservable()
          .map { _ in Mutation.ignore },
        .just(.updateCurrentMusic(shuffleMusic())),
        .just(.updateCurrentVersion(repository.currentVersion)),
      ])
      .timeout(.seconds(10), other: Observable.just(Mutation.updateLoading(false)), scheduler: scheduler)

    case let .playMusicButtonTapped(second):
      self.second = second
      return .concat([
        .just(.updatePlayStopState(true)),
      ])

    case .didPlayToggleButtonTapped:
      return .just(.updatePlayStopState(!currentState.isPlaying))

    case .didAnswerButtonTapped:
      return .just(.updateAnswer(currentAnswer()))

    case .shuffle:
      guard playerState != .pending else { return .empty() }
      playerState = .pending
      return .concat(
        .just(.updateLoading(true)),
        .just(.updatePlayStopState(false)),
        .just(.updateAnswer(nil)),
        .just(.updateCurrentMusic(shuffleMusic()))
      )

    case .needCurrentVersion:
      return .just(.updateCurrentVersion(repository.currentVersion))

    case let .playerState(state):
      return playerStateHandler(state)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updatePlayStopState(boolean):
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
    let randomNumber = Int(arc4random()) % size

    return repository.musicList[randomNumber]
  }

  // `YTPlayerView.playVideo()` 호출 시점과 실제 재생 시점이 다름
  // `YTPlayerView` 의 state 를 확인해서 재생 타이머를 수행
  private func playerStateHandler(_ state: PlayerState) -> Observable<Mutation> {
    playerState = state
    guard playerState != .pending else { return .empty() }

    switch playerState {
    case .playing:
      return .just(.updatePlayStopState(false))
    case .ready:
      return .just(.updateLoading(false))
    case .cued:
      second = nil
      fallthrough
    default:
      return .empty()
    }
  }
}

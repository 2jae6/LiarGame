//
//  RandomMusicQuizViewController.swift
//  LiarGame
//
//  Created by JK on 2022/04/21.
//

import ReactorKit
import RxSwift
import Then
import UIKit

final class RandomMusicQuizViewController: UIViewController, View {

  // MARK: Properties

  var disposeBag = DisposeBag()
  private let content = RandomQuizView()

  // MARK: Initilaize

  init(reactor: RandomMusicQuizReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: LifeCycle

  override func loadView() {
    super.loadView()
    view = content
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor.map {
      $0.action.onNext(.needCurrentVersion)
      $0.action.onNext(.shuffle)
    }
  }

  // MARK: Bind Reactor

  func bind(reactor: RandomMusicQuizReactor) {
    bindAction(with: reactor)
    bindState(with: reactor)
  }

}

extension RandomMusicQuizViewController {
  private func bindAction(with reactor: RandomMusicQuizReactor) {
    bindButtons(with: reactor)
    bindYTPlayerState(with: reactor)
  }

  private func bindState(with reactor: RandomMusicQuizReactor) {
    reactor.state.map(\.answer)
      .distinctUntilChanged { $0?.title == $1?.title && $0?.artist == $1?.artist }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.setAnswerLabel)
      .disposed(by: disposeBag)

    reactor.state.map(\.currentVersion)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.setVersionLabel)
      .disposed(by: disposeBag)

    reactor.state.map(\.currentMusic)
      .distinctUntilChanged()
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak content] in
        content?.ytPlayer.load(
          withVideoId: $0.id,
          playerVars: [
            "start": $0.startedAt
          ])
      })
      .disposed(by: disposeBag)

    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.setLoading(_:))
      .disposed(by: disposeBag)

    reactor.state.map(\.isPlaying)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.changePlayButtonState(isPlaying:))
      .disposed(by: disposeBag)

    reactor.state.map(\.isPlaying)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.updatePlayingAnimation(_:))
      .disposed(by: disposeBag)

  }

  // MARK: Binding Buttons

  private func bindButtons(with reactor: RandomMusicQuizReactor) {
    content.threeSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusicButtonTapped(second: .three) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.fiveSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusicButtonTapped(second: .five) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.tenSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusicButtonTapped(second: .ten) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.playButton.rx.tap
      .map { _ in Reactor.Action.didPlayToggleButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.updateButton.rx.tap
      .map { _ in Reactor.Action.updateMusicList }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.shuffleButton.rx.tap
      .map { _ in Reactor.Action.shuffle }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.showAnswerButton.rx.tap
      .map { _ in Reactor.Action.didAnswerButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  // MARK: YTPlayer State Binding

  private func bindYTPlayerState(with reactor: RandomMusicQuizReactor) {
    content.ytPlayer.rx.isReady
      .map { _ in Reactor.Action.playerState(.ready) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    content.ytPlayer.rx.state
      .map {
        let playerState: YoutubePlayerState
        switch $0 {
        case .playing:
          playerState = .playing
        case .buffering:
          playerState = .buffering
        case .cued:
          playerState = .cued
        default:
          playerState = .unknwon
        }
        return playerState
      }
      .map { Reactor.Action.playerState($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

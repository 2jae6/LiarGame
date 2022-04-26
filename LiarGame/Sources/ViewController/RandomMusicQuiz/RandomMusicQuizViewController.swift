//
//  RandomMusicQuizViewController.swift
//  LiarGame
//
//  Created by JK on 2022/04/21.
//

import UIKit
import ReactorKit
import RxSwift
import Then

final class RandomMusicQuizViewController: UIViewController, View {
  
  private let content = RandomQuizView()
  
  init(reactor: RandomMusicQuizReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  override func loadView() {
    super.loadView()
    self.view = content
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor.map {
      $0.action.onNext(.needCurrentVersion)
      $0.action.onNext(.shuffle)
    }
  }
  
  var disposeBag = DisposeBag()
  func bind(reactor: RandomMusicQuizReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: RandomMusicQuizReactor) {
    content.threeSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusic(second: .three) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    content.fiveSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusic(second: .five) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    content.tenSecondButton.rx.tap
      .map { _ in Reactor.Action.playMusic(second: .ten) }
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
    
    content.ytPlayer.rx.isReady
      .map { _ in Reactor.Action.playerReady }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  }
  
  private func bindState(reactor: RandomMusicQuizReactor) {
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
      .subscribe(onNext: { [weak self] in
        self?.content.ytPlayer.load(withVideoId: $0.id, playerVars: [
          "start": $0.startedAt
        ])
      })
      .disposed(by: disposeBag)

    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .subscribe(onNext: content.setLoading(_:))
      .disposed(by: disposeBag)

    reactor.state.map(\.isPlaying)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: content.changePlayButtonState(isPlaying:))
      .disposed(by: disposeBag)
    
  }
  
}


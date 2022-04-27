//
//  HomeViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController, View {
  typealias Reactor = HomeReactor

  init(reactor: HomeReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    setupView()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flexLayoutContainer.pin.all(view.pin.safeArea)
    flexLayoutContainer.flex.layout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemPink
  }

  private let flexLayoutContainer: UIView = .init()

  var disposeBag: DisposeBag = .init()

  private lazy var gameList = [liarGameStartButton, randomMusicQuizButton]
  private let liarGameStartButton = makeGameButton(str: "라이어 게임")
  private let randomMusicQuizButton = makeGameButton(str: "랜덤 음악 맞추기")
}

// MARK: - Setup View

extension HomeViewController {
  private func setupView() {
    view.addSubview(flexLayoutContainer)
    flexLayoutContainer.flex.direction(.column).alignItems(.center).justifyContent(.center).padding(10).define { flex in
      gameList.forEach {
        flex.addItem($0)
          .width(200)
          .height(50)
          .backgroundColor(.yellow)
      }
    }
    .verticallySpacing(15)
  }
}

// MARK: - Binding

extension HomeViewController {
  func bind(reactor: Reactor) {
    liarGameStartButton.rx.tap
      .subscribe(onNext: {
        reactor.action.onNext(.updateMode(.liarGame))
      })
      .disposed(by: disposeBag)

    randomMusicQuizButton.rx.tap
      .map { _ in Reactor.Action.updateMode(.randomMusicQuiz) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // TODO: -  해당 부분에서 `fullScreen` 으로 `present` 가 이루어지므로 메뉴로 돌아갈 기능 필요
    reactor.state.map(\.mode)
      .compactMap { $0 }
      .withUnretained(self)
      .subscribe(onNext: { `self`, mode in
        switch mode {
        case .liarGame:
          let liarVC = LiarGameModeViewController(reactor: LiarGameModeReactor())
          liarVC.modalPresentationStyle = .fullScreen
          self.present(liarVC, animated: true)
        case .randomMusicQuiz:
          let reactor = RandomMusicQuizReactor(repository: RandomMusicRepository())
          let vc = RandomMusicQuizViewController(reactor: reactor)
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
}

private func makeGameButton(str: String) -> UIButton {
  let button = UIButton()

  button.setTitle(str, for: .normal)
  button.setTitleColor(.black, for: .normal)
  button.setTitleColor(.systemGray, for: .normal)

  return button
}

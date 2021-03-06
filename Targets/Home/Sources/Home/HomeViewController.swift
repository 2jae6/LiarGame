//
//  HomeViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import FlexLayout
import LiarGame
import PinLayout
import Pure
import RandomMusic
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

public final class HomeViewController: UIViewController, View, FactoryModule {
  // MARK: Depdency & Payload

  public struct Dependency {
    public let reactorFactory: HomeReactor.Factory

    let randomMusicDependency: RandomMusicDependency
    let liarGameDependency: LiarGameDependency
  }

  public struct Payload {
    let reactor: HomeReactor

    public init(reactor: HomeReactor) {
      self.reactor = reactor
    }
  }

  // MARK: Properties

  private let dependency: Dependency
  private let flexLayoutContainer: UIView = .init()

  public var disposeBag: DisposeBag

  private lazy var gameList = [liarGameStartButton, randomMusicQuizButton]
  private let liarGameStartButton = makeGameButton(str: "라이어 게임")
  private let randomMusicQuizButton = makeGameButton(str: "랜덤 음악 맞추기")

  // MARK: Initialize

  public init(dependency: Dependency, payload: Payload) {
    defer { reactor = payload.reactor }
    self.dependency = dependency
    disposeBag = .init()
    super.init(nibName: nil, bundle: nil)
    setupView()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Life Cycle

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flexLayoutContainer.pin.all(view.pin.safeArea)
    flexLayoutContainer.flex.layout()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .background
  }
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
          .backgroundColor(.primaryColor)
      }
    }
    .verticallySpacing(15)
  }
}

// MARK: - Binding

extension HomeViewController {
  public func bind(reactor: HomeReactor) {
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
          let factory = self.dependency.liarGameDependency.liarGameModeViewControllerFacotry
          let reactor = factory.dependency.reactorFactory.create()
          let liarVC = factory.create(payload: .init(reactor: reactor))

          liarVC.modalPresentationStyle = .fullScreen
          self.navigationController?.pushViewController(liarVC, animated: true)
        case .randomMusicQuiz:
          let factory = self.dependency.randomMusicDependency.randomMusicFactory
          let reactor = factory.dependency.reactorFactory.create()

          let vc = factory.create(payload: .init(reactor: reactor))
          vc.modalPresentationStyle = .fullScreen
          self.navigationController?.pushViewController(vc, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
}

private func makeGameButton(str: String) -> UIButton {
  let button = UIButton()

  button.setTitle(str, for: .normal)
  button.setTitleColor(.white, for: .normal)
  button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

  return button
}

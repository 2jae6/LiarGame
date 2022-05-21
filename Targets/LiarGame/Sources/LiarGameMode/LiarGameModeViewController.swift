//
//  LiarGameModeViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/19.
//

import UIKit

import FlexLayout
import PinLayout
import Pure
import ReactorKit
import RxCocoa
import RxSwift

public final class LiarGameModeViewController: UIViewController, View, FactoryModule {

  public struct Dependency {
    public let reactorFactory: LiarGameModeReactor.Factory
    let liarGameSubjectFactory: LiarGameSubjectViewController.Factory
  }

  public struct Payload {
    public let reactor: LiarGameModeReactor

    public init(reactor: LiarGameModeReactor) {
      self.reactor = reactor
    }
  }

  private let dependency: Dependency

  public init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    self.dependency = dependency
    super.init(nibName: nil, bundle: nil)
    setLayout()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLayoutSubviews() {
    flexLayoutContainer.pin.all()
    flexLayoutContainer.flex.layout()
  }

  public override func viewDidLoad() {
    view.backgroundColor = .background
    setupView()
    bindingStepper()
  }

  private let flexLayoutContainer = UIView()
  public var disposeBag = DisposeBag()

  private let defaultLiarGame = UIButton()
  private let stupidLiarGame = UIButton()
  private let memberCountLabel = UILabel()
  private let memberCountStepper = UIStepper().then {
    $0.wraps = false
    $0.autorepeat = true
    $0.minimumValue = 3
    $0.maximumValue = 20
  }

}

// MARK: - Setup View
extension LiarGameModeViewController {
  private func setupView() {
    defaultLiarGame.do {
      $0.setTitle("일반 모드", for: .normal)
      $0.setTitleColor(.black, for: .normal)
      self.view.addSubview($0)
    }
    stupidLiarGame.do {
      $0.setTitle("바보 모드", for: .normal)
      $0.setTitleColor(.black, for: .normal)
      self.view.addSubview($0)
    }
    memberCountLabel.do {
      $0.textAlignment = .center
      self.view.addSubview($0)
    }
    memberCountStepper.do {
      self.view.addSubview($0)
    }
  }
}

// MARK: - Bind
extension LiarGameModeViewController {
  public func bind(reactor: LiarGameModeReactor) {

    defaultLiarGame.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { Reactor.Action.selectMode(LiarGameMode.normal) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    stupidLiarGame.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { Reactor.Action.selectMode(LiarGameMode.stupid) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map { $0.mode }
      .compactMap { $0 }
      .distinctUntilChanged()
      .withUnretained(self)
      .subscribe(onNext: { `self`, mode in
        let factory = self.dependency.liarGameSubjectFactory
        let reactor = factory.dependency.reactorFactory.create()

        let liarGameSubjectVC = factory.create(
          payload: .init(
            reactor: reactor,
            mode: mode,
            memberCount: Int(self.memberCountStepper.value)))
        liarGameSubjectVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(liarGameSubjectVC, animated: true)
      }).disposed(by: disposeBag)

  }

  private func bindingStepper() {
    memberCountStepper.rx.value
      .map { String(Int($0)) }
      .bind(to: memberCountLabel.rx.text)
      .disposed(by: disposeBag)
  }

  private func setLayout() {
    view.addSubview(flexLayoutContainer)
    flexLayoutContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).padding(10).define { flex in
      flex.addItem(defaultLiarGame).width(200).height(50).backgroundColor(.primaryColor)
      flex.addItem(stupidLiarGame).width(200).height(50).backgroundColor(.primaryColor).marginTop(10)
      flex.addItem(memberCountLabel).width(200).height(50).backgroundColor(.white).marginTop(30)
      flex.addItem(memberCountStepper).backgroundColor(.red).marginTop(10)
    }
  }

}

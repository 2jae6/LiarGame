//
//  LiarGameSubjectViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import UIKit

import FlexLayout
import PinLayout
import Pure
import ReactorKit
import Then

final class LiarGameSubjectViewController: UIViewController, View, FactoryModule {

  struct Dependency {
    let reactorFactory: LiarGameSubjectReactor.Factory

    let liarGameFactory: LiarGameViewController.Factory
  }

  struct Payload {
    let reactor: LiarGameSubjectReactor
    let mode: LiarGameMode
    let memberCount: Int
  }

  // MARK: Properties

  private let dependency: Dependency
  private var mode: LiarGameMode
  private var memberCount = 3
  var disposeBag = DisposeBag()

  // MARK: UI

  private let flexLayoutContainer = UIView()
  private var subjectButtons = LiarGameSubject.allCases.map { SubjectButtonWrapped(subject: $0, button: $0.createButton()) }

  // MARK: Initialize

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    mode = payload.mode
    memberCount = payload.memberCount
    self.dependency = dependency
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: View Lifecycle
  override func viewDidLoad() {
    view.backgroundColor = .background
    setLayout()
  }

  // MARK: Layout

  override func viewDidLayoutSubviews() {
    flexLayoutContainer.pin.all(view.pin.safeArea)
    flexLayoutContainer.flex.layout()
  }

  private func setLayout() {
    view.addSubview(flexLayoutContainer)
    flexLayoutContainer.flex.direction(.row).justifyContent(.center).alignItems(.stretch).wrap(.wrap).define { flex in
      subjectButtons.forEach {
        flex.addItem($0.button).width(100).height(25).margin(10)
      }
    }
  }

  // MARK: Bind
  func bind(reactor: LiarGameSubjectReactor) {
    bindSubjectButtonTapped(with: reactor)
    bindMoveToGame(with: reactor)
  }
}

// MARK: - Binding Method

extension LiarGameSubjectViewController {
  private func bindSubjectButtonTapped(with reactor: LiarGameSubjectReactor) {
    subjectButtons.forEach {
      let button = $0.button
      let subject = $0.subject
      button.rx.tap
        .map { _ in Reactor.Action.selectSubject(subject) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }

  private func bindMoveToGame(with reactor: LiarGameSubjectReactor) {
    reactor.state.map { $0.selectedSubject }
      .compactMap { $0 }
      .distinctUntilChanged()
      .withUnretained(self)
      .subscribe(onNext: { `self`, subject in
        let factory = self.dependency.liarGameFactory
        let reactor = factory.dependency.reactorFactory.create()

        let liarGameVC = factory.create(payload: .init(
          reactor: reactor,
          mode: self.mode,
          memberCount: self.memberCount,
          subject: subject))
        liarGameVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(liarGameVC, animated: true)
      }).disposed(by: disposeBag)
  }
}

private struct SubjectButtonWrapped {
  let subject: LiarGameSubject
  let button: UIButton
}

extension LiarGameSubject {
  private var title: String {
    switch self {
    case .job: return "직업"
    case .food: return "음식"
    case .animal: return "동물"
    case .exercise: return "운동"
    case .electronicEquipment: return "전자기기"
    }
  }

  fileprivate func createButton() -> UIButton {
    let button = UIButton()
    button.backgroundColor = .yellow
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }
}

//
//  LiarGameSubjectViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/20.
//

import FlexLayout
import PinLayout
import ReactorKit
import Then
import UIKit

final class LiarGameSubjectViewController: UIViewController, View {

  // MARK: Properties

  private var mode: LiarGameMode
  private var memberCount = 3
  var disposeBag = DisposeBag()

  // MARK: UI

  private let flexLayoutContainer = UIView()
  private let animalButton = UIButton().then {
    $0.backgroundColor = .yellow
    $0.setTitle("동물", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  private let exerciseButton = UIButton().then {
    $0.backgroundColor = .yellow
    $0.setTitle("운동", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  private let foodButton = UIButton().then {
    $0.backgroundColor = .yellow
    $0.setTitle("음식", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  private let electronicEquipmentButton = UIButton().then {
    $0.backgroundColor = .yellow
    $0.setTitle("전자기기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  private let jobButton = UIButton().then {
    $0.backgroundColor = .yellow
    $0.setTitle("직업", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  // MARK: Initialize

  init(reactor: LiarGameSubjectReactor, mode: LiarGameMode, memberCount: Int) {
    defer { self.reactor = reactor }
    self.mode = mode
    self.memberCount = memberCount
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: View Lifecycle

  override func viewDidLoad() {
    view.backgroundColor = UIColor(hexString: "EDE6DB")
  }

  // MARK: Layout

  override func viewDidLayoutSubviews() {
    setLayout()
  }

  private func setLayout() {
    view.addSubview(flexLayoutContainer)

    flexLayoutContainer.flex.direction(.row).justifyContent(.center).alignItems(.stretch).wrap(.wrap).define { flex in
      flex.addItem(self.animalButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.exerciseButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.foodButton).width(100).height(25).marginTop(100).margin(10)
      flex.addItem(self.electronicEquipmentButton).width(100).height(25).marginTop(10).margin(10)
      flex.addItem(self.jobButton).width(100).height(25).marginTop(10).margin(10)
    }

    flexLayoutContainer.pin.all()
    flexLayoutContainer.flex.layout()
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
    animalButton.rx.tap
      .subscribe(onNext: { [weak reactor] in
        reactor?.action.onNext(.selectSubject(.animal))
      }).disposed(by: disposeBag)

    exerciseButton.rx.tap
      .subscribe(onNext: { [weak reactor] in
        reactor?.action.onNext(.selectSubject(.exercise))
      }).disposed(by: disposeBag)

    foodButton.rx.tap
      .subscribe(onNext: { [weak reactor] in
        reactor?.action.onNext(.selectSubject(.food))
      }).disposed(by: disposeBag)

    electronicEquipmentButton.rx.tap
      .subscribe(onNext: { [weak reactor] in
        reactor?.action.onNext(.selectSubject(.electronicEquipment))
      }).disposed(by: disposeBag)

    jobButton.rx.tap.asDriver()
      .drive(onNext: { [weak reactor] in
        reactor?.action.onNext(.selectSubject(.job))
      }).disposed(by: disposeBag)
  }

  private func bindMoveToGame(with reactor: LiarGameSubjectReactor) {
    reactor.state.map { $0.selectedSubject }
      .compactMap { $0 }
      .distinctUntilChanged()
      .withUnretained(self)
      .subscribe(onNext: { `self`, subject in
        let liarGameVC = LiarGameViewController(
          reactor: LiarGameReactor(),
          subject: subject,
          mode: self.mode,
          memberCount: self.memberCount)
        liarGameVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(liarGameVC, animated: true)
      }).disposed(by: disposeBag)
  }
}

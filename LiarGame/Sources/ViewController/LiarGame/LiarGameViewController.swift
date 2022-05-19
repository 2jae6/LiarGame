//
//  LiarGameViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/26.
//

import FlexLayout
import PinLayout
import Pure
import ReactorKit
import RxCocoa
import RxSwift
import Then
import UIKit

final class LiarGameViewController: UIViewController, View, FactoryModule {
  
  // MARK: Depdency & Payload
  
  struct Dependency {
    let reactorFactory: LiarGameReactor.Factory
  }

  struct Payload {
    let reactor: LiarGameReactor
    let mode: LiarGameMode
    let memberCount: Int
    let subject: LiarGameSubject
  }

  // MARK: Properties

  private let dependency: Dependency
  private var selectSubject: LiarGameSubject // 주제
  private var mode: LiarGameMode // 게임 모드
  private var memberCount: Int
  private var turn = 0
  var disposeBag = DisposeBag()

  // MARK: UI

  private let flexContainer = UIView()

  // 가림막 만들기 가림막은 클릭 시 확인창이 뜸
  private let curtainView = UIView()
  private let curtainLabel = UILabel().then {
    $0.text = "터치해서 가림막을 제거해주세요"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .background
    $0.textAlignment = .center
  }

  private let curtainButton = UIButton().then {
    $0.backgroundColor = .subColor
  }

  // 단어 나타나기 화면 만들기
  private let liarView = UIView()
  private let liarLabel = UILabel().then {
    $0.text = "라이어 게임 테스트"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .background
    $0.textAlignment = .center
  }

  private let liarButton = UIButton().then {
    $0.backgroundColor = .primaryColor
  }

  // 게임 시작!!!
  private let endView = UIView().then {
    $0.isHidden = true
    $0.backgroundColor = UIColor.secondaryColor
  }

  private let endLabel = UILabel().then {
    $0.text = "게임을 시작하세요!\n해당 화면을 터치하면 주제를 다시 선택합니다."
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .background
  }

  private let endButton = UIButton().then {
    $0.backgroundColor = .clear
  }

  // MARK: Initialize

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }

    selectSubject = payload.subject
    memberCount = payload.memberCount
    mode = payload.mode
    self.dependency = dependency

    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Lifecycle

  override func viewDidLoad() {
    view.backgroundColor = .background
    setupView()
  }

  private func setupView() {
    setupLiarView()
    setupCurtainView()
    setupEndView()
  }

  // MARK: Binding

  func bind(reactor: LiarGameReactor) {
    reactor.action.onNext(.initWord(memberCount, selectSubject, mode))

    bindLiarLabel(with: reactor)
    bindCurtainButton(with: reactor)
    bindLiarButton(with: reactor)
    bindEndButton(with: reactor)
  }

  // MARK: View Handling

  private func changeView(currentView: UIView, newView: UIView) {
    guard currentView != newView else { return }

    let oldView: UIView = currentView

    UIView.transition(with: newView, duration: 1.0, options: .transitionCurlUp) {
      newView.alpha = 1.0
      oldView.alpha = 0.0
    }

  }

  // MARK: Layout

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    layoutLiarView()
    layoutCurtainView()
    layoutEndView()
  }

  private func layoutLiarView() {
    liarView.pin.width(300).height(300).center()
    liarLabel.pin.width(200).height(40).center()
    liarButton.pin.all()
  }

  private func layoutCurtainView() {
    curtainView.pin.width(300).height(300).center()
    curtainLabel.pin.width(200).height(40).center()
    curtainButton.pin.all()
  }

  private func layoutEndView() {
    endView.pin.width(300).height(300).center()
    endLabel.pin.width(300).height(40).center()
    endButton.pin.all()
  }
}

// MARK: - Setup

extension LiarGameViewController {
  private func setupLiarView() {
    view.addSubview(liarView)
    liarView.addSubview(liarButton)
    liarView.addSubview(liarLabel)
  }

  private func setupCurtainView() {
    view.addSubview(curtainView)
    curtainView.addSubview(curtainButton)
    curtainView.addSubview(curtainLabel)
  }

  private func setupEndView() {
    view.addSubview(endView)
    endView.addSubview(endButton)
    endView.addSubview(endLabel)
  }
}

// MARK: - Bind

extension LiarGameViewController {
  private func bindLiarLabel(with reactor: LiarGameReactor) {
    reactor.state.map { $0.liarSetText }
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: liarLabel.rx.text)
      .disposed(by: disposeBag)
  }

  private func bindCurtainButton(with reactor: LiarGameReactor) {
    curtainButton.rx.tap
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.showAlert(okButtonHandler: { [weak self, weak reactor] in
          guard let self = self else { return }
          reactor?.action.onNext(.tappedCurtain)
          self.changeView(currentView: self.curtainView, newView: self.liarView)
        })
      })
      .disposed(by: disposeBag)
  }

  private func showAlert(okButtonHandler: (() -> Void)?) {
    let alert = UIAlertController(
      title: "보기",
      message: "본인의 차례가 맞다면 보기를 눌러주세요",
      preferredStyle: .alert)

    let okAction = UIAlertAction(
      title: "보기",
      style: .default) { _ in
        okButtonHandler?()
      }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    alert.addAction(okAction)
    alert.addAction(cancelAction)

    present(alert, animated: false, completion: nil)
  }

  private func bindLiarButton(with reactor: LiarGameReactor) {
    liarButton.rx.tap
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if self.turn == self.memberCount - 1 {
          self.updateGameState()
          return
        }

        self.turn += 1

        self.showAlert2(okButtonHandler: { [weak self, weak reactor] in
          guard let self = self else { return }
          self.changeView(currentView: self.liarView, newView: self.curtainView)
          reactor?.action.onNext(.tappedLiar)
        })
      }).disposed(by: disposeBag)
  }

  private func updateGameState() {

    curtainView.isHidden = true
    liarView.isHidden = true

    UIView.transition(with: endView, duration: 0.7, options: .transitionFlipFromRight) { [weak self] in
      self?.endView.isHidden = false
    }
  }

  private func showAlert2(okButtonHandler: (() -> Void)?) {
    let alert = UIAlertController(
      title: "확인하셨나요?",
      message: "확인버튼을 누르고 다음 차례로 넘겨주세요!",
      preferredStyle: .alert)
    let okAction = UIAlertAction(
      title: "확인",
      style: .default) { _ in
        okButtonHandler?()
      }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    alert.addAction(okAction)
    alert.addAction(cancelAction)

    present(alert, animated: false, completion: nil)
  }

  private func bindEndButton(with _: LiarGameReactor) {
    endButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

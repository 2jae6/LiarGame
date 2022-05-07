//
//  LiarGameViewController.swift
//  LiarGame
//
//  Created by Jay on 2022/04/26.
//

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import RxSwift
import Then
import UIKit

final class LiarGameViewController: UIViewController, View {

  // MARK: Properties

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
    $0.backgroundColor = .blue
    $0.text = "터치해서 가림막을 제거해주세요"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }

  private let curtainButton = UIButton().then {
    $0.backgroundColor = .red
  }

  // 단어 나타나기 화면 만들기
  private let liarView = UIView()
  private let liarLabel = UILabel().then {
    $0.backgroundColor = .red
    $0.text = "라이어 게임 테스트"
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }

  private let liarButton = UIButton().then {
    $0.backgroundColor = .green
  }

  // 게임 시작!!!
  private let endView = UIView().then {
    $0.isHidden = true
  }

  private let endLabel = UILabel().then {
    $0.backgroundColor = .blue
    $0.text = "게임을 다시 시작하려면 아래 버튼을 눌러주세요."
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
  }

  private let endButton = UIButton().then {
    $0.backgroundColor = .red
  }

  // MARK: Initialize

  init(reactor: LiarGameReactor, subject: LiarGameSubject, mode: LiarGameMode, memberCount: Int) {
    defer { self.reactor = reactor }

    selectSubject = subject
    self.memberCount = memberCount
    self.mode = mode
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Lifecycle

  override func viewDidLoad() {
    view.backgroundColor = UIColor(hexString: "EDE6DB")
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
  }

  // MARK: View Handling

  private func changeView(currentView: UIView, newView: UIView) {
    guard currentView != newView else { return }

    let oldView: UIView = currentView
    oldView.alpha = 0.0
    oldView.isHidden = true

    newView.isHidden = false
    newView.alpha = 1.0

    UIView.animate(
      withDuration: Double(0.5),
      animations: {
        newView.alpha = 1.0
        oldView.alpha = 0.0
      })
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
    endLabel.pin.width(200).height(40).center()
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
        self?.updateGameState()
        self?.showAlert2(okButtonHandler: { [weak self, weak reactor] in
          guard let self = self else { return }
          self.changeView(currentView: self.liarView, newView: self.curtainView)
          reactor?.action.onNext(.tappedLiar)
        })
      }).disposed(by: disposeBag)
  }

  private func updateGameState() {
    if turn == memberCount - 1 {
      print("게임이 종료되었습니다.")
      endView.isHidden = false
      curtainView.isHidden = true
      liarView.isHidden = true
    } else {
      turn += 1
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
}

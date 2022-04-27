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

final class LiarGameViewController: UIViewController {
  init(subject: LiarGameSubject) {
    selectSubject = subject
    super.init(nibName: nil, bundle: nil)
    flexContainer.flex.define { flex in
      flex.addItem(self.curtainView)
    }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLayoutSubviews() {
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }

  override func viewDidLoad() {
    view.backgroundColor = .yellow
    setupView()
  }

  private let flexContainer: UIView = .init()

  private var selectSubject: LiarGameSubject
  // 가림막 만들기 가림막은 클릭 시 확인창이 뜸
  private let curtainView: UIView = .init()
  private let curtainLabel: UILabel = .init()
  private let curtainButton: UIButton = .init()

  // 단어 나타나기 화면 만들기
  private let liarView: UIView = .init()
  private let liarLabel: UILabel = .init()
  private let liarButton: UIButton = .init()

  // 게임 시작!!!
  private let endView: UIView = .init()
  private let endLabel: UILabel = .init()
  private let endButton: UIButton = .init()
}

extension LiarGameViewController {
  private func setupView() {
//        self.view.addSubview(flexContainer)

    curtainView.do {
      self.view.addSubview($0)
      $0.backgroundColor = .yellow
    }

    curtainLabel.do {
      self.curtainView.addSubview($0)
      $0.backgroundColor = .green
      $0.text = "터치해서 가림막을 제거해주세요"
    }
    curtainButton.do {
      self.curtainView.addSubview($0)
    }
  }
}

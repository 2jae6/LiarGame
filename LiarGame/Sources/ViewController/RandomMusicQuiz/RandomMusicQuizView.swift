//
//  RandomMusicQuizView.swift
//  LiarGame
//
//  Created by JK on 2022/04/26.
//

import UIKit
import FlexLayout
import PinLayout
import YouTubeiOSPlayerHelper

final class RandomQuizView: UIView {
  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  init() {
    super.init(frame: .zero)
    setupViews()
  }
  
  
  fileprivate let container = UIView()
  private let _tintColor = UIColor(hexString: "1D5C63")
  
  private lazy var threeSecondButton = makeRoundedButton(tintColor: _tintColor, str: "3초")
  private lazy var fiveSecondButton = makeRoundedButton(tintColor: _tintColor, str: "5초")
  private lazy var tenSecondButton = makeRoundedButton(tintColor: _tintColor, str: "10초")
  private lazy var playButton = makeRoundedButton(tintColor: _tintColor, str: "재생")
  
  private lazy var currentVersionLabel = UILabel().then {
    $0.textColor = .label
  }
  
  private lazy var updateButton = makeRoundedButton(tintColor: _tintColor).then {
    $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
  }
  private lazy var shuffleButton = makeRoundedButton(tintColor: _tintColor).then {
    $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
  }

  private lazy var showAnswerButton = makeRoundedButton(tintColor: _tintColor, str: "정답 보기")
  
  private lazy var answerLabel = DashedLineBorderdLabel(borderColor: _tintColor).then {
    $0.font = .preferredFont(forTextStyle: .title1)
    $0.isHidden = true
  }
  
  private let ytPlayer = YTPlayerView(frame: .zero)
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    container.pin.all(pin.safeArea)
    container.flex.layout()
  }
  
  private func setupViews() {
    backgroundColor = UIColor(hexString: "EDE6DB")
    addSubview(container)
    
    container.flex
      .direction(.column).justifyContent(.center).marginHorizontal(20).define {
        // 장르 선택 영역
        $0.addItem(UILabel().then { $0.text = "Genre Area"; $0.backgroundColor = .systemGray; $0.textAlignment = .center })
          .width(100%).aspectRatio(1.0)
          .shrink(1)
        
        $0.addItem().direction(.row).height(150).justifyContent(.spaceAround).alignItems(.end).define {
          $0.addItem(shuffleButton).padding(8)
          
          $0.addItem().direction(.column).justifyContent(.start).alignItems(.center).define {
            $0.addItem(currentVersionLabel)
            $0.addItem(updateButton).padding(8)
              .marginTop(8)
          }
        }
        
        $0.addItem().direction(.row).height(40).justifyContent(.spaceEvenly).define { flex in
          [playButton, threeSecondButton, fiveSecondButton, tenSecondButton].forEach {
            flex.addItem($0)
              .grow(1)
          }
        }
        .horizontallySpacing(10)
        
        $0.addItem().height(30)
        
        $0.addItem(showAnswerButton)
          .width(150).height(50)
          .alignSelf(.center)
        $0.addItem(answerLabel)
          .minHeight(answerLabel.font.lineHeight)
          .minWidth(75)
          .alignSelf(.center)
        
      }
      .verticallySpacing(20)
    
  }
  
  func setAnswerLabel(_ value: String?) {
    if value != nil {
      answerLabel.isHidden = false
      answerLabel.text = value
    } else {
      answerLabel.isHidden = true
    }
  }
  
}

fileprivate func makeRoundedButton(tintColor: UIColor, str: String? = nil) -> UIButton {
  let button = UIButton()
  
  button.layer.cornerRadius = 15
  button.layer.cornerCurve = .continuous
  button.backgroundColor = tintColor
  button.tintColor = .white
  str.map {
    button.setTitle($0, for: .normal)
    button.setTitleColor(.systemGray, for: .highlighted)
  }
  
  return button
}

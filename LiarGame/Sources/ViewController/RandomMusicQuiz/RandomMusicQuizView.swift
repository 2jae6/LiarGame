//
//  RandomMusicQuizView.swift
//  LiarGame
//
//  Created by JK on 2022/04/26.
//

import UIKit

import FlexLayout
import Lottie
import PinLayout
import YouTubeiOSPlayerHelper

final class RandomQuizView: UIView {

  // MARK: Properties

  // YTPlayer
  let ytPlayer = YTPlayerView(frame: .zero)

  // Buttons
  lazy var threeSecondButton = makeButton(tintColor: _tintColor, str: "3초")
  lazy var fiveSecondButton = makeButton(tintColor: _tintColor, str: "5초")
  lazy var tenSecondButton = makeButton(tintColor: _tintColor, str: "10초")
  lazy var playButton = makeButton(tintColor: _tintColor, str: "재생")
  lazy var showAnswerButton = makeButton(tintColor: _tintColor, str: "정답 보기")
  lazy var updateButton = makeButton(tintColor: _tintColor).then {
    $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
  }

  lazy var shuffleButton = makeButton(tintColor: _tintColor).then {
    $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
  }

  // Labels
  private lazy var currentVersionLabel = UILabel().then {
    $0.textColor = .label
    $0.font = .preferredFont(forTextStyle: .caption1)
  }

  private lazy var answerLabel = DashedLineBorderdLabel(borderColor: _tintColor).then {
    $0.font = .preferredFont(forTextStyle: .title1)
    $0.isHidden = true
  }

  // Lottie Animation
  private let musicPlayingAnimation = AnimationView(name: "music_playing").then {
    $0.loopMode = .loop
  }

  private var loadingView: UIView?
  fileprivate let container = UIView()
  private let _tintColor = UIColor.primaryColor

  // MARK: Initialize

  init() {
    super.init(frame: .zero)
    setupViews()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: LifeCycle

  override func layoutSubviews() {
    super.layoutSubviews()

    container.pin.all(pin.safeArea)
    container.flex.layout()
  }

  // MARK: Update View

  func setAnswerLabel(_ value: (title: String, artist: String)?) {
    if let value = value {
      answerLabel.text = "\(value.title) - \(value.artist)"
      answerLabel.isHidden = false
      answerLabel.flex.markDirty()
      container.flex.layout()
    } else {
      answerLabel.isHidden = true
    }
  }

  func setVersionLabel(_ value: String) {
    currentVersionLabel.text = "현재 버전: \(value)"
    currentVersionLabel.flex.markDirty()
    container.flex.layout()
  }

  func changePlayButtonState(isPlaying: Bool) {
    [threeSecondButton, fiveSecondButton, tenSecondButton]
      .forEach { $0.isEnabled = !isPlaying }
    playButton.setTitle(isPlaying ? "정지" : "시작", for: .normal)
    if isPlaying { ytPlayer.playVideo() } else { ytPlayer.stopVideo() }
  }

  func setLoading(_ value: Bool) {
    if value {
      let loadingBackground = UIView(frame: bounds).then {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.5)
      }
      let indicator = UIActivityIndicatorView(style: .large)
      indicator.color = _tintColor

      addSubview(loadingBackground)
      loadingBackground.addSubview(indicator)
      indicator.center = center
      loadingView = loadingBackground
      indicator.startAnimating()
    } else {
      loadingView?.removeFromSuperview()
    }
  }

  func updatePlayingAnimation(_ value: Bool) {
    if value { musicPlayingAnimation.play() } else { musicPlayingAnimation.pause() }
  }

}

extension RandomQuizView {

  // MARK: Setup UI

  private func setupViews() {
    backgroundColor = .background
    addSubview(container)
    container.addSubview(ytPlayer)
    ytPlayer.isHidden = true

    container.flex
      .direction(.column).justifyContent(.start).marginHorizontal(20).define {
        $0.addItem(currentVersionLabel)
          .alignSelf(.end)

        $0.addItem().height(20%)

        // 셔플 , 버전 업데이트
        $0.addItem().direction(.row).justifyContent(.start).alignItems(.start).define { flex in
          [shuffleButton, updateButton].forEach {
            flex.addItem($0)
              .size(30)
          }
        }
        .horizontallySpacing(5)

        // 재생 버튼
        $0.addItem().direction(.row).height(40).justifyContent(.spaceBetween).define { flex in
          [playButton, threeSecondButton, fiveSecondButton, tenSecondButton].forEach {
            flex.addItem($0)
              .grow(1)
          }
        }
        .horizontallySpacing(10)

        $0.addItem().height(10)

        // 정답 영역
        $0.addItem(showAnswerButton)
          .width(150).height(50)
          .alignSelf(.center)
        $0.addItem(answerLabel)
          .padding(1)
          .alignSelf(.center)

        $0.addItem().grow(1)

        $0.addItem(musicPlayingAnimation)
          .width(50%)
          .aspectRatio(1.0)
          .alignSelf(.center)

      }
      .verticallySpacing(20)
  }

  // MARK: Create Button Mehtod

  private func makeButton(tintColor: UIColor, str: String? = nil) -> UIButton {
    let button = UIButton()

    button.backgroundColor = tintColor
    button.tintColor = .white
    str.map {
      button.setTitle($0, for: .normal)
      button.setTitleColor(.systemGray, for: .highlighted)
    }

    return button
  }
}

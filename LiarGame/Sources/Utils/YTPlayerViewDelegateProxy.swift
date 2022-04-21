//
//  YTPlayerViewDelegateProxy.swift
//  LiarGame
//
//  Created by JK on 2022/04/20.
//

import Foundation
import UIKit.UIColor
import UIKit.UIView
import RxSwift
import RxCocoa
import RxRelay
import YouTubeiOSPlayerHelper
import UIKit

final class RxYTPlayerDelegateProxy
: DelegateProxy<YTPlayerView, YTPlayerViewDelegate>,
  DelegateProxyType, YTPlayerViewDelegate {
  
  public weak private(set) var ytPlayer: YTPlayerView?
  
  init(ytPlayer: YTPlayerView) {
    self.ytPlayer = ytPlayer
    super.init(parentObject: ytPlayer, delegateProxy: RxYTPlayerDelegateProxy.self)
  }
  
  static func registerKnownImplementations() {
    self.register { RxYTPlayerDelegateProxy(ytPlayer: $0) }
  }
  
  static func currentDelegate(for object: YTPlayerView) -> YTPlayerViewDelegate? {
    object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: YTPlayerViewDelegate?, to object: YTPlayerView) {
    object.delegate = delegate
  }
  
}

extension Reactive where Base: YTPlayerView {
  private var delegate: DelegateProxy<YTPlayerView, YTPlayerViewDelegate> {
    RxYTPlayerDelegateProxy.proxy(for: base)
  }
  
  var state: Observable<YTPlayerState> {
    delegate
      .methodInvoked(#selector(YTPlayerViewDelegate.playerView(_:didStateChanged:)))
      .map { try castOrThrow(Int.self, $0[1]) }
      .map { YTPlayerState(rawValue: $0)! }
  }
  
  var isReady: Observable<YTPlayerView> {
    delegate
      .methodInvoked(#selector(YTPlayerViewDelegate.playerViewDidBecomeReady(_:)))
      .map { _ in base }
  }
  
  var quality: Observable<YTPlaybackQuality> {
    delegate
      .methodInvoked(#selector(YTPlayerViewDelegate.playerView(_:didQualityChanged:)))
      .map { try castOrThrow(YTPlaybackQuality.self, $0[1]) }
  }
  
  var playTime: Observable<Float> {
    delegate
      .methodInvoked(#selector(YTPlayerViewDelegate.playerView(_:didPlayTime:)))
      .map { try castOrThrow(Float.self, $0[1]) }
  }
  
  var error: Observable<YTPlayerError> {
    delegate
      .methodInvoked(#selector(YTPlayerViewDelegate.playerView(_:receivedError:)))
      .map { try castOrThrow(YTPlayerError.self, $0[1]) }
  }
  
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

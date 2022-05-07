//
//  YoutubePlayerState.swift
//  LiarGame
//
//  Created by JK on 2022/05/08.
//

import Foundation

enum YoutubePlayerState {
  /// 비디오 로드 후 대기 중
  case pending
  /// 비디오 로드 완료
  case ready
  /// 비디오 재생 시 버퍼링
  case buffering
  /// 비디오 재생 중
  case playing
  /// 재생정지(stopVideo) 호출 시 cued
  case cued
  case unknwon
}

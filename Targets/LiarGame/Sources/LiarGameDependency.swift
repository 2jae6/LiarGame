//
//  LiarGameDependency.swift
//  LiarGame
//
//  Created by 송준권 on 2022/05/20.
//

import Foundation

public struct LiarGameDependency {
  public let liarGameModeViewControllerFacotry: LiarGameModeViewController.Factory
}

extension LiarGameDependency {
  public static func resolve() -> LiarGameDependency {
    let liarGameReactor = LiarGameReactor.Factory()
    let liarGameVC = LiarGameViewController.Factory(dependency: .init(reactorFactory: liarGameReactor))

    let liarGameSubjectReactor = LiarGameSubjectReactor.Factory()
    let liarGameSubjectVC = LiarGameSubjectViewController.Factory(
      dependency: .init(
        reactorFactory: liarGameSubjectReactor,
        liarGameFactory: liarGameVC))

    let liarGameModeReactor = LiarGameModeReactor.Factory()
    let liarGameModeVC = LiarGameModeViewController.Factory(dependency: .init(
      reactorFactory: liarGameModeReactor,
      liarGameSubjectFactory: liarGameSubjectVC))

    return LiarGameDependency(liarGameModeViewControllerFacotry: liarGameModeVC)
  }
}

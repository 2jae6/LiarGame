//
//  AppDependency.swift
//  LiarGame
//
//  Created by 송준권 on 2022/05/19.
//

import Foundation

import Pure

struct AppDependency {
  let rootViewControllerFactory: SplashViewController.Factory
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let randomMusicRepository = RandomMusicRepository()

    let randomMusicReactor = RandomMusicQuizReactor.Factory(dependency: .init(repository: randomMusicRepository))
    let randomMusicVC = RandomMusicQuizViewController.Factory(dependency: .init(reactorFactory: randomMusicReactor))

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

    let homeReactor = HomeReactor.Factory()
    let homeVC = HomeViewController.Factory(
      dependency: .init(
        reactorFactory: homeReactor,
        randomMusicQuizFactory: randomMusicVC,
        liarGameModeFactory: liarGameModeVC))

    let splashVC = SplashViewController.Factory(dependency: .init(
      homeViewControllerFactory: homeVC))

    return AppDependency(rootViewControllerFactory: splashVC)
  }
}

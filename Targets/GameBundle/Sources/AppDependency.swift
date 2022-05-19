//
//  AppDependency.swift
//  LiarGame
//
//  Created by 송준권 on 2022/05/19.
//

import Foundation

import Home
import LiarGame
import Pure
import RandomMusic

struct AppDependency {
  let rootViewControllerFactory: SplashViewController.Factory
}

extension AppDependency {
  static func resolve() -> AppDependency {

    let randomMusic = RandomMusicDependency.resolve()
    let liarGame = LiarGameDependency.resolve()

    let home = HomeDependency.resolve(
      randomMusicDependency: randomMusic,
      liarGameDependency: liarGame)

    let splashVC = SplashViewController.Factory(dependency: .init(homeDependency: home))

    return AppDependency(rootViewControllerFactory: splashVC)
  }
}

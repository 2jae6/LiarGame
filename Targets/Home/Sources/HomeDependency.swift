//
//  HomeDependency.swift
//  Home
//
//  Created by 송준권 on 2022/05/20.
//

import Foundation
import LiarGame
import RandomMusic

public struct HomeDependency {
  public let homeViewControllerFactory: HomeViewController.Factory
}

extension HomeDependency {
  public static func resolve(
    randomMusicDependency: RandomMusicDependency,
    liarGameDependency: LiarGameDependency)
    -> HomeDependency {
    let homeReactor = HomeReactor.Factory()

    let homeVC = HomeViewController.Factory(
      dependency: .init(
        reactorFactory: homeReactor,
        randomMusicDependency: randomMusicDependency,
        liarGameDependency: liarGameDependency))

    return HomeDependency(homeViewControllerFactory: homeVC)
  }
}

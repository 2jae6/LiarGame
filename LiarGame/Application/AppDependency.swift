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
    let splashVC = SplashViewController.Factory(dependency: .init())

    return AppDependency(rootViewControllerFactory: splashVC)
  }
}

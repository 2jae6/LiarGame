//
//  RandomMusicDependency.swift
//  LiarGame
//
//  Created by 송준권 on 2022/05/20.
//

import Foundation

public struct RandomMusicDependency {
  public let randomMusicFactory: RandomMusicQuizViewController.Factory
}

extension RandomMusicDependency {
  public static func resolve() -> RandomMusicDependency {
    let randomMusicRepository = RandomMusicRepository()

    let randomMusicReactor = RandomMusicQuizReactor.Factory(dependency: .init(repository: randomMusicRepository))
    let randomMusicVC = RandomMusicQuizViewController.Factory(dependency: .init(reactorFactory: randomMusicReactor))

    return RandomMusicDependency(randomMusicFactory: randomMusicVC)
  }
}

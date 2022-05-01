//
//  LiarGameModel.swift
//  LiarGame
//
//  Created by Jay on 2022/05/01.
//

import Foundation

struct LiarGameModel {
  let word: String
  let subject: LiarGameSubject
}

struct LiarGameList {

  let list: [LiarGameModel] = [
    LiarGameModel(word: "개발자", subject: .job),
    LiarGameModel(word: "디자이너", subject: .job)
  ]

}

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

  var list: [LiarGameModel] = []

  init() {
    appendSubject()
  }

  private mutating func appendSubject() {

    // MARK: Animal

    list.append(contentsOf: [
      LiarGameModel(word: "강아지", subject: .animal),
      LiarGameModel(word: "고양이", subject: .animal)
    ])

    // MARK: Exercise

    list.append(contentsOf: [
      LiarGameModel(word: "헬스", subject: .exercise),
      LiarGameModel(word: "축구", subject: .exercise)
    ])

    // MARK: ElectronicEquipment
    list.append(contentsOf: [
      LiarGameModel(word: "아이패드", subject: .electronicEquipment),
      LiarGameModel(word: "애플워치", subject: .electronicEquipment)
    ])

    // MARK: Job

    list.append(contentsOf: [
      LiarGameModel(word: "개발자", subject: .job),
      LiarGameModel(word: "디자이너", subject: .job)
    ])

    // MARK: Food

    list.append(contentsOf: [
      LiarGameModel(word: "짜장면", subject: .food),
      LiarGameModel(word: "아메리카노", subject: .food)
    ])

  }

}

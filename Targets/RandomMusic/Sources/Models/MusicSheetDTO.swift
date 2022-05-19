//
//  MusicSheetDTO.swift
//  LiarGame
//
//  Created by JK on 2022/04/22.
//

import Foundation

// MARK: - MusicSheetDTO

struct MusicSheetDTO: Decodable {
  let range, majorDimension: String
  let values: [[String]]
}

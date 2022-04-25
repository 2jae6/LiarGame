//
//  Music.swift
//  LiarGame
//
//  Created by JK on 2022/04/22.
//

import Foundation

struct Music: Codable, Equatable {
    let title: String
    let artist: String
    /// youtube video ID
    let id: String
    let startedAt: Float

    /** Music 생성자

      들어오는 배열의 구조:
      [title, artist,id, startedAt]

      - title: 노래 제목
      - artist: 가수
      - id: 유튜브 동영상 id
      - startedAt: 첫 재생 시각

      길이가 맞지 않을 경우 `return nil`
     */
    init?(from array: [String]) {
        guard array.count == 4,
              let startedAt = Float(array[3]) else { return nil }

        title = array[0]
        artist = array[1]
        id = array[2]
        self.startedAt = startedAt
    }
}

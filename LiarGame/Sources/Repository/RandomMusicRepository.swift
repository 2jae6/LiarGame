//
//  RandomMusicRepository.swift
//  LiarGame
//
//  Created by JK on 2022/04/22.
//

import Foundation
import RxSwift

protocol RandomMusicRepositoryType {
  /// 최신 버전을 확인합니다.
  var newestVersion: Single<String> { get }
  /// 현재 저장되어 있는 버전을 확인합니다.
  var currentVersion: String { get }
  /// 버전 업데이트를 수행합니다.
  func getNewestVersion() -> Single<[Music]>
  /// 저장되어있는 음악 리스트를 가져옵니다.
  var musicList: [Music] { get }
}

final class RandomMusicRepository: RandomMusicRepositoryType {
  /// 리스트를 담고 있는 Google Sheet ID
  private var sheetID: String = "1jiAcDhKOoMbfLmlCOba33CMAZCwlpaV3enkLVvjMmIA"
  private var googleAPIKey: String {
    (Bundle.main.object(forInfoDictionaryKey: "GOOGLE_APIKEY") as? String) ?? ""
  }

  /// 현재 저장되어 있는 버전
  var currentVersion: String {
    Self._currentVersion
  }

  @UserDefault(key: "RandomMusicVersion", defaultValue: "unknwon")
  private static var _currentVersion: String

  /** 저장되어있는 음악 목록을 가져옵니다.

   최신 버전을 보증하지 않음.
   */
  var musicList: [Music] {
    do {
      return try readMuicList()
    } catch {
      return []
    }
  }

  var newestVersion: Single<String> {
    _newsetVersion
      .map { $0.components(separatedBy: ",")[0] }
  }

  func setCurrent(version: String) {
    Self._currentVersion = version
  }

  /// 버전 확인 후 최신 버전을 가져옵니다.
  func getNewestVersion() -> Single<[Music]> {
    _newsetVersion
      .flatMap { _version -> Single<[Music]> in
        let arr = _version.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
        let version = arr[0]
        let length = arr[1]
        guard version != self.currentVersion else { return .just(try self.readMuicList()) }

        return self.update(version: version, length: length)
      }
  }

  /// 최신 목록으로 업데이트를 수행합니다.
  private func update(version: String, length: String) -> Single<[Music]> {
    guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/Sheet!A2:D\(length)?key=\(googleAPIKey)") else {
      assertionFailure("URL String error")
      return .error(RandomMusicRepositoryError.castingError)
    }

    return URLSession.shared.rx.response(request: URLRequest(url: url))
      .map { response, data -> Data in
        guard 200 ..< 300 ~= response.statusCode else {
          throw RandomMusicRepositoryError.requestFailed
        }

        return data
      }
      .asSingle()
      // 타입 변환
      .map { data -> MusicSheetDTO in
        do {
          return try JSONDecoder().decode(MusicSheetDTO.self, from: data)
        } catch {
          throw RandomMusicRepositoryError.parseError
        }
      }
      .map(\.values)
      .map { $0.compactMap(Music.init) }
      // 저장
      .do(onSuccess: { musicList in
        self.setCurrent(version: version)
        try self.writeMusicList(from: musicList)
      })
  }

  /** 최신 정보를 받아옵니다.

   return 값인 String 의 구조는 다음과 같습니다.

   [업데이트된버전],[시트의 마지막행]

   ex) 20220422,5
   */
  private var _newsetVersion: Single<String> {
    guard let url = URL(string: "https://dl.dropboxusercontent.com/s/g55fwxp70a16xl1/version.txt") else {
      assertionFailure("URL String error")
      return .error(RandomMusicRepositoryError.castingError)
    }
    let request = URLRequest(url: url)
    return URLSession.shared.rx.data(request: request)
      .map {
        guard let str = String(data: $0, encoding: .utf8) else {
          throw RandomMusicRepositoryError.requestFailed
        }

        return str
      }
      .asSingle()
  }

  /// 음악 데이터 저장
  private func writeMusicList(from musicList: [Music]) throws {
    if musicList.isEmpty { fatalError() }
    let path = try musicDataPath()
    do {
      let data = try JSONEncoder().encode(musicList)
      try data.write(to: path, options: .atomic)
    } catch {
      throw RandomMusicRepositoryError.fileWriteFailed
    }
  }

  /// 음악 데이터 읽어오기
  private func readMuicList() throws -> [Music] {
    let path = try musicDataPath()
    let data = try Data(contentsOf: path)

    return try JSONDecoder().decode([Music].self, from: data)
  }

  /// 음악 데이터를 저장하는 경로
  private func musicDataPath() throws -> URL {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      throw RandomMusicRepositoryError.fileAccessFailed
    }

    return documentsURL.appendingPathComponent("MusicListData.bin")
  }
}

enum RandomMusicRepositoryError: Error {
  case requestFailed
  case castingError
  case parseError
  case fileAccessFailed
  case fileWriteFailed
}

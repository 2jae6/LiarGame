//
//  Userdefaults+PropertyWrapper.swift
//  LiarGame
//
//  Created by JK on 2022/04/22.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
  public let key: String
  public let defaultValue: Value
  public var container: UserDefaults = .standard

  public var wrappedValue: Value {
    get {
      container.object(forKey: key) as? Value ?? defaultValue
    }
    set {
      container.set(newValue, forKey: key)
    }
  }

  public init(key: String, defaultValue: Value) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

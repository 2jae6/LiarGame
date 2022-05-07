//
//  UIColor+Extensions.swift
//  LiarGame
//
//  Created by JK on 2022/04/26.
//

import UIKit

extension UIColor {
  static let background = UIColor(hexString: "EDE6DB")
  static let primaryColor = UIColor(hexString: "417D7A")
  static let secondaryColor = UIColor(hexString: "1D5C63")
  static let subColor = UIColor(hexString: "1A3C40")
}

extension UIColor {
  convenience init(hexString: String) {
    if let rgbValue = UInt(hexString, radix: 16) {
      let red = CGFloat((rgbValue >> 16) & 0xFF) / 255
      let green = CGFloat((rgbValue >> 8) & 0xFF) / 255
      let blue = CGFloat(rgbValue & 0xFF) / 255
      self.init(red: red, green: green, blue: blue, alpha: 1.0)
    } else {
      self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
  }
}

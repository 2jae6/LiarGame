//
//  Flex+Extensions.swift
//  LiarGame
//
//  Created by JK on 2022/04/26.
//

import CoreGraphics
import FlexLayout
import Foundation

extension Flex {
  @discardableResult
  public func horizontallySpacing(_ value: CGFloat?) -> Flex {
    guard let view = view, view.subviews.count > 1 else { return self }
    for (idx, subview) in view.subviews.enumerated() {
      if idx == 0 { continue }
      subview.flex.marginLeft(value ?? 0)
    }
    return self
  }

  @discardableResult
  public func verticallySpacing(_ value: CGFloat?) -> Flex {
    guard let view = view, view.subviews.count > 1 else { return self }
    for (idx, subview) in view.subviews.enumerated() {
      if idx == 0 { continue }
      subview.flex.marginTop(value ?? 0)
    }
    return self
  }
}

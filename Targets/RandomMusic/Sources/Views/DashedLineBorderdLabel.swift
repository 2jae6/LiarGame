//
//  DashedLineBorderdLabel.swift
//  LiarGame
//
//  Created by JK on 2022/04/26.
//

import UIKit

final class DashedLineBorderdLabel: UILabel {
  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }
  init(cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.0, borderColor: UIColor) {
    self.borderWidth = borderWidth
    self.borderColor = borderColor
    self.cornerRadius = cornerRadius
    super.init(frame: .zero)
    layer.cornerRadius = cornerRadius
  }

  private let borderWidth: CGFloat
  private let borderColor: UIColor
  private let cornerRadius: CGFloat

  var dashBorder: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()

    dashBorder?.removeFromSuperlayer()
    let dashBorder = CAShapeLayer()
    dashBorder.lineWidth = borderWidth
    dashBorder.strokeColor = borderColor.cgColor
    dashBorder.lineDashPattern = [3, 2]
    dashBorder.frame = bounds
    dashBorder.fillColor = nil
    let horizontalInset = 8.0
    let verticalInset = 4.0
    let bounds = CGRect(
      x: bounds.origin.x - horizontalInset,
      y: bounds.origin.y - verticalInset,
      width: bounds.width + horizontalInset * 2,
      height: bounds.height + verticalInset * 2)
    dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    layer.addSublayer(dashBorder)
    self.dashBorder = dashBorder
  }
}

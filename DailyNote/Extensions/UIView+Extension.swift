// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension UIView {
    func addDashedBorder(color: UIColor = .red, cornerRadius: CGFloat = 0, lineWidth: CGFloat = 2, dashPattern: [NSNumber] = [6, 4]) {
        let dashedBorder = CAShapeLayer()
        dashedBorder.frame = bounds
        dashedBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        dashedBorder.strokeColor = color.cgColor
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = lineWidth
        dashedBorder.lineDashPattern = dashPattern

        layer.addSublayer(dashedBorder)
    }
}

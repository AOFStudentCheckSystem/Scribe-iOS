//
//  RoundCornerUIView.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorner(radius: CGFloat, shadowRadius: CGFloat, borderWidth: CGFloat, shadowOpacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shouldRasterize = false
        layer.cornerRadius = radius
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = borderWidth
        layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
}

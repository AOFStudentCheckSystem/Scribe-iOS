//
//  UIColorExtension.swift
//  Scribe
//
//  Created by Codetector on 2017/4/27.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithRGB(color: UInt) -> UIColor{
        return UIColor(colorLiteralRed: Float((color & 0xFF0000) >> 16) / 255.0,
                       green: Float((color & 0x00FF00) >> 8) / 255.0,
                       blue: Float(color & 0x0000FF) / 255.0, alpha: 1)
    }
}

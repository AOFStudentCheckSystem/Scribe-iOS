//
//  UIUtil.swift
//  Scribe
//
//  Created by Codetector on 2017/4/28.
//  Copyright © 2017年 Codetector. All rights reserved.
//

import Foundation
import UIKit
class UIUtil {
    class func string(forEventStatus status: Int) -> NSAttributedString {
        var string: NSAttributedString?
        switch status {
            case 0:
                string = NSAttributedString(string: NSLocalizedString("EVENT_STATUS_FUTURE", comment: "Future Event"), attributes: [NSForegroundColorAttributeName: UIColor.colorWithRGB(color: 0x007aff)])
            case 1:
                string = NSAttributedString(string: NSLocalizedString("EVENT_STATUS_BOARDING", comment: "Future Event"), attributes: [NSForegroundColorAttributeName: UIColor.colorWithRGB(color: 0xffcc00)])
            case 2:
                string = NSAttributedString(string: NSLocalizedString("EVENT_STATUS_COMPLETE", comment: "Future Event"), attributes: [NSForegroundColorAttributeName: UIColor.colorWithRGB(color: 0x4cd964)])
            default:
                string = NSAttributedString(string: NSLocalizedString("EVENT_STATUS_UNKNOWN", comment: "Future Event"), attributes: [NSForegroundColorAttributeName: UIColor.darkText])
        }
        return string!
    }
}

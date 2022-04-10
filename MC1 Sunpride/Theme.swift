//
//  Theme.swift
//  MC1 Sunpride
//
//  Created by Ramadhan Kalih Sewu on 07/04/22.
//

import Foundation
import UIKit

enum Theme: UInt32
{
    case hexTabBarItemSelected    = 0xFAC710
    case hexTabBarItemUnselected  = 0x6F6F99
    case hexTabBarTint            = 0xFFFFFF
    case hexHeaderTitle           = 0x000000
    
    public static func loadTheme()
    {
    }
}

extension UIColor
{
    convenience init(_ hexRGB: Theme)
    {
        self.init(
            red:   CGFloat((hexRGB.rawValue >> 16) & 0xFF),
            green: CGFloat((hexRGB.rawValue >> 8) & 0xFF),
            blue:  CGFloat((hexRGB.rawValue >> 0) & 0xFF),
            alpha: 1.0
        )
    }
}

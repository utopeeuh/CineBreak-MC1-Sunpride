//
//  UIView+Extension.swift
//  MC1 Sunpride
//
//  Created by Nikita Felicia on 07/04/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}

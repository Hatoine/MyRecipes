//
//  UIImageView.swift
//  Recipes
//
//  Created by Antoine Antoniol on 27/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extensions

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let border = layer.borderColor else { return UIColor()}
            return UIColor(cgColor: border)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}







//
//  Designable.swift
//  PpakCoder
//
//  Created by 성제 on 2022/11/03.
//

import Foundation
import UIKit

@IBDesignable
class RoundedView : UIView {
    @IBInspectable
    var borderWidth : CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor : UIColor = UIColor.gray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius : CGFloat = 12 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var hasShadow : Bool = false {
        didSet {
            if hasShadow {
                self.layer.applyShadow()
            }
        }
    }
}

@IBDesignable
class RoundedButton : UIButton {
    @IBInspectable
    var borderWidth : CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor : UIColor = UIColor.gray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius : CGFloat = 12 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var hasShadow : Bool = false {
        didSet {
            if hasShadow {
                self.layer.applyShadow()
            }
        }
    }
}

extension CALayer {
    // Sketch 스타일의 그림자
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.25,
        x: CGFloat = 0,
        y: CGFloat = 4,
        blur: CGFloat = 10
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

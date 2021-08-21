//
//  UIKit+Extension.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import UIKit

extension UIView {
    
    /// x
    var mm_x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var mm_y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var mm_height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var mm_width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var mm_size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    /// centerX
    var mm_centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    /// centerY
    var mm_centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }
    
    var mm_origin: CGPoint {
        set {
            frame.origin = newValue
        }
        get {
            return frame.origin
        }
    }
}

extension UIView {
    func mm_cornerRadius(_ radius: CGFloat) -> Void {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func checkSubViewRemove(checkViewStr: String) -> Void {
        if self.subviews.count < 1 {
            return
        }
        for subView in self.subviews {
            let str = String(describing: type(of: subView))
            if str == checkViewStr {
                subView.removeFromSuperview()
                break
            }
        }
    }
}

extension UILabel {
    class func labelWith(title: String?, titleColor: UIColor?, font: UIFont?, alignment: NSTextAlignment = NSTextAlignment.left) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        if let titleT = title {
            label.text = titleT
        }
        if let colorT = titleColor {
            label.textColor = colorT
        }
        if let fontT = font {
            label.font = fontT
        }
        label.textAlignment = alignment
        label.sizeToFit()
        return label
    }
}

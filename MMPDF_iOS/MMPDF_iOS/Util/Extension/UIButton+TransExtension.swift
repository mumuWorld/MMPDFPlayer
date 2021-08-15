//
//  UIButton+TransExtension.swift
//  YDTransMain
//
//  Created by 杨杰 on 2021/3/29.
//

import UIKit

public extension UIButton {
    
    class func create(_ title: String = "") -> UIButton {
        let btn = UIButton(type: .custom)
        if !title.isEmpty {
            btn.setTitle(title, for: .normal)
        }
        return btn
    }
    
    @discardableResult
    func title(_ title: String) -> UIButton {
        setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func selectedTitle(_ title: String) -> UIButton {
        setTitle(title, for: .selected)
        return self
    }
    
//    @discardableResult
//    func fontType(_ type: YDTransFontType) -> UIButton {
//        titleLabel?.font = UIFont.font(type: type)
//        return self
//    }
    
    @discardableResult
    func font(_ font: UIFont?) -> UIButton {
        titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor?) -> UIButton {
        setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func selectedTextColor(_ color: UIColor) -> UIButton {
        setTitleColor(color, for: .selected)
        return self
    }
    
//    @discardableResult
//    func image(_ imgName: String) -> UIButton {
//        setImage(Res.image(named: imgName), for: .normal)
//        return self
//    }
    
    @discardableResult
    func image(_ img: UIImage?) -> UIButton {
        setImage(img, for: .normal)
        return self
    }
    
//    @discardableResult
//    func selectedImg(_ imgName: String) -> UIButton {
//        setImage(Res.image(named: imgName), for: .selected)
//        return self
//    }
    
    @discardableResult
    func selectedImg(_ img: UIImage?) -> UIButton {
        setImage(img, for: .selected)
        return self
    }
    
    
    @discardableResult
    func disableColor(_ color: UIColor) -> UIButton {
        setTitleColor(color, for: .disabled)
        return self
    }
}



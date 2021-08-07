//
//  UIViewController+Extension.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/7.
//

import UIKit

public extension UIViewController {
    
    @objc class func currentViewController() -> UIViewController? {
        return currentViewController(base: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    @objc class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        guard let base = base else {
            return nil
        }
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let lastChild = base.children.last, lastChild is UINavigationController {
            return currentViewController(base: lastChild)
        }
        if let presented = base.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

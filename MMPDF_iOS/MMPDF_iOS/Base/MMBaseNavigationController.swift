//
//  MMBaseNavigationController.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import Foundation
import UIKit

class MMBaseNavigationController: UINavigationController {
    
    open var isInteracitvePopEnable = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        navigationBar.isHidden = true
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            //viewController是将要被push的控制器
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension MMBaseNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            if self.viewControllers.count <= 1 {
                return false
            }
        }
        return isInteracitvePopEnable
    }
}

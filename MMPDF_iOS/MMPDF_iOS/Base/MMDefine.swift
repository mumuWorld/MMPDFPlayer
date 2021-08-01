//
//  MMDefine.swift
//  MMPDF_iOS
//
//  Created by Mumu on 2021/8/1.
//

import Foundation
import UIKit

public let application = UIApplication.shared

public var kScreenWidth = UIScreen.main.bounds.size.width

public var kScreenHeigh = UIScreen.main.bounds.size.height

public var kStatusBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        let height = application.delegate?.window??.safeAreaInsets.top ?? 0.0
        if height > 20 {
            return height
        } else {
            return 20
        }
    } else {
        return 20
    }
}()

public let kNavigationHeight: CGFloat = 44

public var kNavigationBarHeight: CGFloat = kNavigationHeight + kStatusBarHeight


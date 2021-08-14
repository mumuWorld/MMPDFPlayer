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

public var kBottomSafeSpacing: CGFloat = {
    if #available(iOS 11.0, *) {
        let height = application.delegate?.window??.safeAreaInsets.bottom ?? 0.0
        if height > 20 {
            return height
        }
    }
    return 0
}()

public let kNavigationHeight: CGFloat = 44

public var kNavigationBarHeight: CGFloat = kNavigationHeight + kStatusBarHeight

let vNormalSpacing: CGFloat = 8


func mm_print(_ messages : Any..., file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
       // 1.获取文件名,包含后缀名
       let name = (file as NSString).lastPathComponent
       // 1.1 切割文件名和后缀名
       let fileArray = name.components(separatedBy: ".")
       // 1.2 获取文件名
       let fileName = fileArray[0]
       // 2.打印内容
       print("🔨[\(fileName) \(funcName)](\(lineNum)): \(messages)")
    #endif
}

//
//  Date+MM_Extension.swift
//  MMQRCode
//
//  Created by yangjie on 2019/8/6.
//  Copyright © 2019 yangjie. All rights reserved.
//

import Foundation

enum kDateFormatterKey: String {
    /// yyyy-MM-dd HH:mm:ss
    case Default = "yyyy-MM-dd HH:mm:ss"
    /// yyyy-MM-dd
    case ShortYMD = "yyyy-MM-dd"
    /// yyyy-MM-dd HH:mm
    case ShortYMDHM = "yyyy-MM-dd HH:mm"
}

extension Date {
    static let shareFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static func currentTimeStamp() -> Int {
        let time = Date().timeIntervalSince1970
        return Int(time)
    }
    
    /// 根据时间戳 int 返回 格式日期字符串
    ///
    /// - Parameters:
    ///   - timeStamp: Int
    ///   - formatter: 格式
    /// - Returns: 日期
    static func dateStr(timeStamp: Int, formatter: kDateFormatterKey = kDateFormatterKey.Default) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        shareFormatter.dateFormat = formatter.rawValue
        let result = shareFormatter.string(from: date)
        return result
    }
}

extension Date {
    func dataStr(formatter: kDateFormatterKey = kDateFormatterKey.Default) -> String {
        let shareFormatter = Date.shareFormatter
        shareFormatter.dateFormat = formatter.rawValue
        let result = shareFormatter.string(from: self)
        return result
    }
}

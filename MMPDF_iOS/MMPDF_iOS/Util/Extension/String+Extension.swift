//
//  UIColor+Extension
//  RZParent
//
//  Created by lijiantao on 2019/11/22.
//  Copyright © 2019 李建涛. All rights reserved.
//

import Foundation
import CommonCrypto
import CoreGraphics
import UIKit

// MARK: - 字符串截取
public extension String {
    
    /// 判断index是否合法
    func judgeLegalIndex(i: Int) -> Bool {
        return i >= 0 && i < count
    }
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int) -> String {
        guard judgeLegalIndex(i: i) else { return self }
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            guard judgeLegalIndex(i: r.lowerBound) , judgeLegalIndex(i: r.upperBound) else { return self }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            guard judgeLegalIndex(i: index) , judgeLegalIndex(i: index + length - 1) else { return self }
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    /// 截取 从头到i位置  abcd[to: 3] -> abc
    func substring(to:Int) -> String {
        return self[0..<to]
    }
    /// 截取 从i到尾部
    func substring(from:Int) -> String {
        return self[from..<self.count]
    }
    
}


extension String {
    //将原始的url编码为合法的url
      func urlEncoded() -> String {
          let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
              .urlQueryAllowed)
          return encodeUrlString ?? ""
      }
       
      //将编码后的url转换回原始的url
      func urlDecoded() -> String {
          return self.removingPercentEncoding ?? ""
      }
}

extension NSString {
    func mm_range() -> NSRange {
        return NSRange(location: 0, length: self.length);
    }
}
//不包含后几个字符串的方法
extension String {
    
    func mm_range() -> NSRange {
        return NSRange(location: 0, length: count)
    }
    
    /// 因为可能包含emoji的情况，所以需要获取utf16的长度
    func mm_attributeRange() -> NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
    
    /// 匹配字符串 返回 NSRange
    /// - Parameter str: 子串
    /// - Returns: 默认返回 0-0
    func mm_nsRangeOfString(str: String) -> NSRange {
        if let tRange = range(of: str) {
            return NSRange(tRange, in: self)
        }
        return NSRange(location: 0, length: 0)
    }
    
    func appendPathComponent(string: String) -> String {
        if self.last == "/" {
            return self + string
        }
        return self + "/" + string
    }
    
    func floatValue() -> CGFloat {
        
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(self)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    func intValue() -> Int {
        guard let intV = Int(self) else {
            return  0
        }
        return intV
    }
}

extension String {
    
    var MD5String: String {
        
        let cStrl = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        
        var md5String = "";
        
        for idx in 0...15 {
            
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            
            md5String.append(obcStrl);
            
        }
        
        free(buffer);
        
        return md5String;
        
    }
    
    func passwordMd5(_ salt:String = "vl!qt$6xC4") -> String {
        let str = self //+ salt
        //return str.MD5String.uppercased()
        return str.MD5String
    }
    
    static func getCurrentVersion() -> String? {
        if let dic = Bundle.main.infoDictionary{
            return dic["CFBundleShortVersionString"] as? String
        }
        return nil
    }
    
    func timeIntervalChangeToTimeStr( _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeInterval:Double = Double(self) ?? 0
       let date:Date = Date.init(timeIntervalSince1970: timeInterval)
       let formatter = DateFormatter.init()
       if dateFormat == nil {
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       }else{
           formatter.dateFormat = dateFormat
       }
       return formatter.string(from: date as Date)
   }
}

//MARK: - 字符串格式校验

enum verifyType{
    
    ///邮箱
    case Email
    ///手机号
    case PhoneNumber
    ///验证码
    case VerificationCode
    ///密码
    case PassWord
    ///理财经理编号
    case EmployeeNo
    ///姓名
    case Name
    ///备注
    case ReMark
    ///纯数字
    case PureDigital
    ///限1~6位数字，0~200000
    case MaxiNum
    ///个人年收入  限数字，10个字节
    case Income
    ///员工工号  限数字，12个字节
    case EmployeesNumber
    ///录入字数没有要求，可以输入数字、英文字母、“—”和“#” (200) 一般用在详细地址录入
    case AddressDetail
    ///座机区号  3-4位数字
    case TeleAreaNumber
    ///家庭电话号码  8位数字
    case TeleNumber
    ///家庭电话分机  1-4位数字
    case TeleExtensionNumber
    ///单位名称 限数字，20个字节
    case CompanyName
    ///银行卡好 0-9 19
    case BankCardNum
    ///身份证号
    case IdCardNumber
    /// 推荐码 p、n、w+6位数字
    case RecommondCode
    /// 0-9 . 金额可用输入字符
    case AvailableMoneyNum
    ///限1~5位数字，0~50000
    case SmallMaxiNum
    ///四位验证码
    case SmallVerificationCode
}

extension String {
    
    func verifyText(type : verifyType) -> Bool {
        
        var regular = ""
        
        if type == .PhoneNumber {
//            regular = "^1\\d{10}$"
            regular = "^1(3[0-9]|4[57]|5[0-35-9]|6[0-9]|7[06-8]|8[0-9]|9[0-9])\\d{8}$"
            //regular = "^1\\d{10}$"
        } else if type == .Name {
            regular = "^[a-zA-Z\\u4e00-\\u9fa5·]{2,10}$"
        } else if type == .ReMark {
            regular = "^[0-9a-zA-Z\\u4e00-\\u9fa5]{1,50}$"
        } else if type == .PassWord {
            regular = "^[a-zA-Z0-9!-¥）（；：？！，。《》～“”!￼$%^&*()_:;\"',<>?.!￼$%^&*()_:;\"',<.>]{6,20}$"
        } else if type == .Email {
            regular = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,3}$"
        } else if type == .VerificationCode {
            regular = "^[0-9]{4}$"
        } else if type == .EmployeeNo{
            regular = "^[0-9]{11}$"
        } else if type == .PureDigital {
            regular = "^[0-9]+$"
        } else if type == .MaxiNum {
            regular = "(^200000$)|(^[1][0-9]{0,5}$)|(^[1-9][0-9]{1,4}$)|(^[0]$)"
        } else if type == .Income {
            regular = "^[0-9]{1,10}$"
        } else if type == .EmployeesNumber {
            regular = "^[0-9]{12}$"
        } else if type == .AddressDetail {
            regular = "^[-\\u4e00-\\u9fa5\\u364da-zA-Z0-9#]{1,200}$"
        } else if type == .TeleNumber {
            regular = "^[0-9]{7,8}$"
        } else if type == .TeleExtensionNumber {
            regular = "^[0-9]{1,4}$"
        }else if type == .TeleAreaNumber {
            regular = "^[0-9]{3,4}$"
        } else if type == .CompanyName {
            regular = "[\\u4e00-\\u9fa5a-zA-Z()（）.]{1,20}$"
        } else if type == .BankCardNum {
            regular = "^[0-9]{13,19}$"
        } else if type == .IdCardNumber {
            regular = "^(^\\d{15}$)|(!\\d{18}$)|(^\\d{17}(\\d|X|x)$)$"
            if NSPredicate(format: "SELF MATCHES %@", regular).evaluate(with:self) {
                return chk18PaperId()
            }
        }else if type == .RecommondCode {
            regular = "^[pnw]\\d{6}$"
        }else if type == .AvailableMoneyNum {
            regular = "^[0-9.]{1}$"
        }else if type == .SmallMaxiNum {
            
            regular = "(^50000$)|(^[1234][0-9]{0,4}$)|(^[1-9][0-9]{1,3}$)|(^[0]$)"
        }else if type == .SmallVerificationCode {
            regular = "^[0-9a-zA-Z]{4,8}$"
        }
        
        else {
            return false
        }
        
        return NSPredicate(format: "SELF MATCHES %@", regular).evaluate(with:self)
        
    }
    
    func chk18PaperId() -> Bool {
        //判断位数
        if self.count != 15 && self.count != 18 {
            return false
        }
        var carid = self.uppercased()
        var lSumQT = 0
        //加权因子
        let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        //校验码
        let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
        //将15位身份证号转换成18位
        let mString = NSMutableString.init(string: self)
        
        if self.count == 15 {
            mString.insert("19", at: 6)
            var p = 0
            let pid = mString.utf8String
            for i in 0...16 {
                p += (Int(pid![i]) - 48) * R[i]
            }
            let o = p % 11
            let stringContent = NSString(format: "%c", sChecker[o])
            mString.insert(stringContent as String, at: mString.length)
            carid = mString as String
        }
        
        //判断地区码
        let sProvince = carid.substring(to: 2)
        if (!areaCodeAt(code: sProvince)) {
            return false
        }
        
        //判断年月日是否有效
        //年份
        let strYear = Int(carid[6..<10])
        //月份
        let strMonth = Int(carid[10..<12])
        //日
        let strDay = Int(carid[12..<14])
        
        let localZone = NSTimeZone.local
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "\(String(format: "%02d",strYear!))-\(String(format: "%02d",strMonth!))-\(String(format: "%02d",strDay!)) 12:01:01")
        
        if date == nil {
            return false
        }
        
        let paperId = carid.utf8CString
        //检验长度
        if 18 != carid.count {
            return false
        }
        //校验数字
        func isDigit(c: Int8) -> Bool {
            return 0 <= c && c <= 9
        }
        for i in 0...18 {
            if isDigit(c: paperId[i]) && !(88 == paperId[i] || 120 == paperId[i]) && 17 == i {
                return false
            }
        }
        //验证最末的校验码
        for i in 0...16 {
            lSumQT += (Int(paperId[i]) - 48) * R[i]
        }
        if sChecker[lSumQT%11] != paperId[17] {
            return false
        }
        return true
    }
    
    func areaCodeAt(code: String) -> Bool {
        var dic: [String: String] = [:]
        dic["11"] = "北京"
        dic["12"] = "天津"
        dic["13"] = "河北"
        dic["14"] = "山西"
        dic["15"] = "内蒙古"
        dic["21"] = "辽宁"
        dic["22"] = "吉林"
        dic["23"] = "黑龙江"
        dic["31"] = "上海"
        dic["32"] = "江苏"
        dic["33"] = "浙江"
        dic["34"] = "安徽"
        dic["35"] = "福建"
        dic["36"] = "江西"
        dic["37"] = "山东"
        dic["41"] = "河南"
        dic["42"] = "湖北"
        dic["43"] = "湖南"
        dic["44"] = "广东"
        dic["45"] = "广西"
        dic["46"] = "海南"
        dic["50"] = "重庆"
        dic["51"] = "四川"
        dic["52"] = "贵州"
        dic["53"] = "云南"
        dic["54"] = "西藏"
        dic["61"] = "陕西"
        dic["62"] = "甘肃"
        dic["63"] = "青海"
        dic["64"] = "宁夏"
        dic["65"] = "新疆"
        dic["71"] = "台湾"
        dic["81"] = "香港"
        dic["82"] = "澳门"
        dic["91"] = "国外"
        if (dic[code] == nil) {
            return false;
        }
        return true;
    }

}


extension String {
    
     func getUrlStrParams() -> [String: String]? {
        
        let urlStrArr = self.components(separatedBy:"?")
        if urlStrArr.count == 2{
            
            let pairs = urlStrArr[1].components(separatedBy: "&")
            var userParams = [String: String]()
                for value in pairs {
                    let kv = value.components(separatedBy: "=")
                    if kv.count == 2{
                        let pValue = kv[1].removingPercentEncoding
                        let pKey = kv[0]
                        userParams[pKey] = pValue
                    }
                }
            

            return userParams
            
        }else{
            return nil
        }
        
    }
    
    ///字符串加密
    func stringReplaceStarWithRange(range:NSRange) -> String {
        
        var Star = ""
        for _ in 0 ..< range.length {
            Star += "*"
        }
        let start = self.index(self.startIndex, offsetBy: range.location)
        let end = self.index(self.startIndex, offsetBy: range.location + range.length)
        return self.replacingCharacters(in: (start..<end), with: Star)
    }
    
    
}


extension String{
    
    /// double 转 str   添加三位逗号
    ///
    /// - Parameters:
    ///   - num: 原始值
    ///  -usesGroupingSeparator  是否显示三位逗号
    ///   - minimumFractionDigits: <#minimumFractionDigits description#>
    ///   - maximumFractionDigits: <#maximumFractionDigits description#>
    /// - Returns: <#return value description#>
    static func hj_FormattingDecimal(num : Double?,
                                      usesGroupingSeparator: Bool = true,
                                     _ minimumFractionDigits: Int = 2,
                                     _ maximumFractionDigits: Int = 2) ->String{
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.usesGroupingSeparator = usesGroupingSeparator
        format.minimumFractionDigits = minimumFractionDigits
        format.maximumFractionDigits = maximumFractionDigits
        if let nu = num, let str = format.string(from: NSNumber.init(value: nu)) {
            return str
        }else{
            return format.string(from: NSNumber.init(value: 0)) ?? ""
        }
        
    }
    
    
    static func hj_FormattingDecimal(numStr : String?,
                                      usesGroupingSeparator: Bool = true,
                                     _ minimumFractionDigits: Int = 2,
                                     _ maximumFractionDigits: Int = 2) ->String{
        
        let format = NumberFormatter()
        format.usesGroupingSeparator = usesGroupingSeparator
        format.numberStyle = .decimal
        format.minimumFractionDigits = minimumFractionDigits
        format.maximumFractionDigits = maximumFractionDigits
        
        if let nums  = numStr, let num  = Double(nums), let str = format.string(from: NSNumber.init(value: num)) {
            return str
        }else{
            return format.string(from: NSNumber.init(value: 0)) ?? ""
        }
        
    }
    
}

extension String {
    
    //des加解密
    func desEncryptOrDecrypt(op: Int) -> String? {
        //op传1位加密，0为解密
        //CCOperation（kCCEncrypt）加密 1
        //CCOperation（kCCDecrypt) 解密 0
        
        var ccop = CCOperation()
        let key = "730216cb6cb04fcb96a8a8286ee9adc8"
        //let iv = nil
        // Key
        let keyData: NSData = (key as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        let keyBytes         = UnsafeRawPointer(keyData.bytes)
        
        // 加密或解密的内容
        var data: NSData = NSData()
        if op == 1 {
            ccop = CCOperation(kCCEncrypt)
            data  = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        }
        else {
            ccop = CCOperation(kCCDecrypt)
            data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        }
        
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeRawPointer(data.bytes)
        
        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSizeDES)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        //  可选 的初始化向量
        //let viData :NSData = (iv as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        //let viDataBytes    = UnsafeRawPointer(viData.bytes)
        
        // 特定的几个参数
        let keyLength              = size_t(kCCKeySizeDES)
        let operation: CCOperation = UInt32(ccop)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmDES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesCrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            nil, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData!.length = Int(numBytesCrypted)
            if op == 1  {
                let base64cryptString =
                    cryptData!.base64EncodedString(options: .lineLength64Characters)
                //返回加密的数据
                return base64cryptString
            }
            else {
                let base64cryptString = NSString(data: cryptData! as Data,  encoding: String.Encoding.utf8.rawValue) as String?
                //返回解密的数据
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }

}

//MARK: -获取字符串宽度
extension String {
    
    func getStringRect(font: CGFloat, w: CGFloat) -> CGSize {
    
        return self.boundingRect(with: CGSize(width: w, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font)], context: nil)
                   .size
    }
    
    /// 获取竖向排列文字
    func getVerticalText() -> String{
        var tempStr = ""
        for (index,text) in self.enumerated() {
            if index == self.count-1 {
                tempStr.append(text)
            }else{
                tempStr.append(text)
                tempStr.append("\n")
            }
        }
        return tempStr
    }
    
}

extension NSAttributedString {
    
    func numberOfLine(width: CGFloat) -> Int {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
//        let path  = CGMutablePath()
        
//        path.addRect(CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), transform: CGAffineTransform(scaleX: 1, y: -1))
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), transform: nil)
        let frame  = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, length), path, nil)
        let rows = CTFrameGetLines(frame)
        let number = CFArrayGetCount(rows)
        return number
    }
}

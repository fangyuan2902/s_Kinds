//
//  StringUtil.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

class StringUtil: NSObject {
    
    //是否为空
    func isNullOrEmpty(string: String) -> Bool {
        return string.isEmpty || string == ""
    }
    
    //去掉空格
    func trimSpacesOfString(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    //验证码验证 推广码 交易密码
    func validateValidateCode(string: String) -> Bool {
        let stringRegex = "^\\d{6}$"
        let validateTest = NSPredicate(format: "SELF MATCHES %@",stringRegex)
        return validateTest.evaluate(with: trimSpacesOfString(string: string))
    }
    
    //手机号码验证
    func validateMobilePhone(string: String) -> Bool {
        let stringRegex = "^1\\d{10}$"
        let validateTest = NSPredicate(format: "SELF MATCHES %@",stringRegex)
        return validateTest.evaluate(with: trimSpacesOfString(string: string))
    }
    
    //验证输入的密码为数字、大小写字母和标点符号
    func validatePassword(string: String) -> Bool {
        let stringRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let validateTest = NSPredicate(format: "SELF MATCHES %@",stringRegex)
        return validateTest.evaluate(with: trimSpacesOfString(string: string))
    }
    
    //身份证号
    func validateIdentity(string: String) -> Bool {
        let stringRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let validateTest = NSPredicate(format: "SELF MATCHES %@",stringRegex)
        return validateTest.evaluate(with: trimSpacesOfString(string: string))
    }
    
    //身份证号后六位
    func validateIdentityForNum(string: String) -> Bool {
        let stringRegex = "^(\\d{5})(\\d|[xX])$"
        let validateTest = NSPredicate(format: "SELF MATCHES %@",stringRegex)
        return validateTest.evaluate(with: trimSpacesOfString(string: string))
    }
    
    /**
     金额单位转换
     @param price    转换前金额
     @param position 保留小数位
     @param showyuan 是否显示元
     @return return value description
     */
    func notRounding(price: Double, position: Int, showyuan: Bool) -> String {
        var bigerThanTenThou: Bool?
        bigerThanTenThou = false
        let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: Int16(position), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        var subtotal = NSDecimalNumber.init(value: price)
        if price >= 10000 {
            bigerThanTenThou = true
            let discount = NSDecimalNumber.init(string: "0.0001")
            subtotal = subtotal.multiplying(by: discount, withBehavior: roundUp)
        }
        var outStr = ""
        if bigerThanTenThou == true {
            outStr = NSString(format: "%.2f万%@", subtotal.doubleValue,(showyuan ? "元" : "")) as String
        } else {
            outStr = NSString(format: "%.2f%@", subtotal.doubleValue,(showyuan ? "元" : "")) as String
        }
        
        return outStr
    }
    
    /**
     textfield能被输入字符的判断
     @param textString 输入字符
     @param string 判断字符
     @return return value description
     */
    func compareOriginalString(textString: String, string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn:string).inverted
        let filtered: String = (textString.components(separatedBy: cs).joined(separator: ""))
        return textString == filtered
    }
    
    //手机号码加空格，格式为xxx xxxx xxxx
    func setGapWith(string: String) -> String {
        let oldString = trimSpacesOfString(string: string)
        let newPhoneString = NSMutableString(string:oldString)
        if (newPhoneString.length > 3) {
            newPhoneString.insert(" ", at: 3)
        }
        if (newPhoneString.length > 8) {
            newPhoneString.insert(" ", at: 8)
        }
        return newPhoneString as String
    }
    
    //时间格式
    func dateFormatterWithFormatString(string: String) -> DateFormatter {
        let threadDic = Thread.current.threadDictionary
//        let formatter: DateFormatter = threadDic.object(forKey: string) as! DateFormatter
        var dateFormatter = threadDic.object(forKey: string)
        if  dateFormatter == nil {
            let formatter: DateFormatter = DateFormatter.init()
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.short
            formatter.dateFormat = string
            dateFormatter = formatter
            threadDic.setValue(dateFormatter, forKey: string)
        }
        return dateFormatter as! DateFormatter
    }
    
    /**
     根据内容改变尺寸
     @param text 输入字符
     @param size 尺寸
     @param font 字体CGSize
     @return return value description
     */
    func boundingRectWithText(textString: String, size: CGSize, font: UIFont) -> CGSize {
        let attribute = NSDictionary.init(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let retSize = textString.boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: attribute as? [NSAttributedStringKey : Any], context: nil).size
        return retSize
    }
    
    //字符串添加千分位
    func setDetailLabelText(countString: String) -> String {
        let newString = NSString(string:trimSpacesOfString(string: countString))
        if newString.isKind(of: NSString.self) {
            var count = 0
            let arr = newString.components(separatedBy: ".")
            let firstStr: NSString = arr.first! as NSString
            var a: Int64 = firstStr.longLongValue
            while (a != 0) {
                count += 1
                a /= 10
            }
            let string = NSMutableString(string:firstStr)
            let newstring = NSMutableString()
            while (count > 3) {
                count -= 3
                let rang = NSMakeRange(string.length - 3, 3)
                let str = string.substring(with: rang)
                newstring.insert(str, at: 0)
                newstring.insert(",", at: 0)
                string.deleteCharacters(in: rang)
            }
            newstring.insert(string as String, at: 0)
            if (arr.count > 1) {
                newstring.append(NSString(format: ".%@", arr.last!) as String)
            }
            return newstring as String
        } else {
            return ""
        }
    }
    
    //根据传过来的卡号，无论多少位 保持四位一空格 xxxx xxxx xxxx xxxx
    func calutateSpace(string: String) -> String {
        if string.isEmpty {
            return ""
        }
        let newString = NSMutableString(string:trimSpacesOfString(string: string))
        if newString.length > 16 {
            for index in 0...3 {
                newString.insert(" ", at: 4 * ( index + 1 ) + index)
            }
        }
        if newString.length > 12 {
            for index in 0...2 {
                newString.insert(" ", at: 4 * ( index + 1 ) + index)
            }
        }
        if newString.length > 8 {
            for index in 0...1 {
                newString.insert(" ", at: 4 * ( index + 1 ) + index)
            }
        }
        if newString.length > 4 {
            newString.insert(" ", at: 4)
        }
        return newString as String
    }
    
    //手机号加星号
    func changeOrgialPhoneString(string: String) -> String {
        let newString = NSString(string:trimSpacesOfString(string: string))
        return starsReplacedOfString(string: newString as String, range:NSMakeRange(3, 4))
    }
    
    /**
     打上星号
     @param string 字符串
     @param range 范围
     @return return value description
     */
    func starsReplacedOfString(string: String, range: NSRange) -> String {
        let newString = NSMutableString(string:trimSpacesOfString(string: string))
        if newString.length == 0 || newString.length < range.location + range.length {
            return newString as String
        }
        let replance = NSString().padding(toLength: 5, withPad: "*", startingAt: 0)
        newString.replaceCharacters(in: range, with: replance)
        return newString as String
    }
    
    //获取姓名的姓
    func firstCharactorWithString(string: String) -> String {
        let newString = NSMutableString(string:trimSpacesOfString(string: string))
        CFStringTransform(newString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(newString, nil, kCFStringTransformStripDiacritics, false)
        let pinYin: NSString = newString.capitalized as NSString
        return pinYin.substring(to: 1)
    }

}

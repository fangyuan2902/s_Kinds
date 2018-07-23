//
//  Util.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/// swift Base64处理
//  编码
func base64Encoding(plainString:String) -> String {
    let plainData = plainString.data(using: String.Encoding.utf8)
    let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    return base64String!
}

//  解码
func base64Decoding(encodedString:String) -> String {
    let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return decodedString
}

func md5String(str:String) -> NSMutableString {
    let cStr = str.cString(using: String.Encoding.utf8);
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
    let md5String = NSMutableString();
    for i in 0 ..< 16{
        md5String.appendFormat("%02x", buffer[i])
    }
    free(buffer)
    return md5String as NSMutableString
}

func returnSignature(arguments : NSMutableDictionary) -> String {
    let sortKey : Array = arguments.allKeys.sorted { (obj1, obj2) -> Bool in
        let res = (obj1 as! String).compare(obj2 as! String).rawValue
        if res == 1 {
            return false
        } else {
            return true
        }
    }
    var mutabelString = NSMutableString()
    for key in sortKey {
        mutabelString.appendFormat("%@=%@", key as! CVarArg, arguments[key]! as! CVarArg)
    }
    mutabelString = md5String(str: mutabelString.copy() as! String)
    mutabelString.append(appSecret)
    mutabelString = md5String(str: mutabelString.copy() as! String)
    return mutabelString.uppercased
}

func appServiceBodyArgumentsAttach(sourceBody : Dictionary<String, Any>) -> Dictionary<String, Any> {
    //    NSLog(@"之前数据 %@",sourceBody);
    let bodyArguments = NSMutableDictionary()
    bodyArguments.addEntries(from: sourceBody)
    if (sourceBody["signa"] != nil) {
        bodyArguments.removeObject(forKey: "signa")
    }
    //appkey
    if (sourceBody["appkey"] == nil) {
        bodyArguments.setValue(appKey, forKey: "appkey")
    }
    //获取时间戳
    let timeStamp : NSInteger = currentTimeStamp()
    bodyArguments.setValue((timeStamp), forKey: "ts")
    //版本号
    if (sourceBody["versionNumber"] == nil) {
        bodyArguments.setValue(versionString(), forKey: "versionNumber")
    }
    //1是代表iOS
    if (sourceBody["mobileType"] == nil) {
        bodyArguments.setValue("1", forKey: "mobileType")
    }
    bodyArguments.setValue("3CD6FE1C19DE387DD728BD63A05787DD", forKey: "appkey")
    bodyArguments.setValue("1530091375060", forKey: "ts")
    //添加用户信息
    if AppUserProfile.shareInstance.isLogin! {
        bodyArguments.setValue(AppUserProfile.shareInstance.__sid, forKey: "__sid")
        bodyArguments.setValue(AppUserProfile.shareInstance.__sid, forKey: "__sid")
    }
    let signa = returnSignature(arguments: bodyArguments)
    bodyArguments.setValue(signa, forKey: "signa")
   
//    print(bodyArguments)
    return bodyArguments as! Dictionary<String, Any>
}

func currentTimeStamp() -> NSInteger {
    let now = Date()
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    return NSInteger(timeInterval * 1000)
}

func versionString() -> String {
    let infoDictionary = Bundle.main.infoDictionary
    let app_Version = infoDictionary!["CFBundleShortVersionString"]
    return app_Version as! String
}

func currentTimeStamp(timeStamp : TimeInterval) -> String {
    //转换为时间
    let timeInterval:TimeInterval = TimeInterval(timeStamp)
    let date = NSDate(timeIntervalSince1970: timeInterval)
    
    //格式话输出
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    print("对应的日期时间：\(dformatter.string(from: date as Date))")
    return dformatter.string(from: date as Date)
}

// 把一个字典转为一个Json字符串
func toJSONString(dict:NSDictionary!)->NSString{
    if (!JSONSerialization.isValidJSONObject(dict)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dict, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString!
}

// 得到当前的时间戳
func getTimeChuo() ->String {
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    print("当前日期时间：\(dformatter.string(from: now))")
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    print("当前时间的时间戳：\(timeStamp)")
    let fininalSring = "\(timeStamp)"
    return fininalSring
}




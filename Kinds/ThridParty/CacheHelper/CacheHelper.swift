//
//  CacheHelper.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

let ARCHIVE_PATH = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last

class CacheHelper: NSObject {
    
    /// UserDefaults
    ///
    /// - Parameters:
    ///   - value: value description
    ///   - key: key description
    func cacheKeyValues(value: NSDictionary, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDictionaryForKey(key: String) -> NSDictionary {
        return UserDefaults.standard.object(forKey: key) as! NSDictionary
    }
    
    func cacheNSArray(value: NSArray, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
//    func cleanNullInJsonArray(value: NSArray) -> NSArray {
//        if value.count == 0 {
//            return value
//        }
//        let array: NSArray = value
//        let mulArray = NSMutableArray.init()
//        for item: NSObject in array {
//            if item.isKind(of: NSNull.self) || item.isKind(of: nil.self) {
//                
//            } else if item.isKind(of: NSDictionary.self) {
//                let dic = item
//                mulArray.add(dic)
//            } else if item.isKind(of: NSArray.self) {
//                let array = cleanNullInJsonArray(value: (item as NSArray))
//                mulArray.add(array)
//            } else {
//               mulArray.add(item)
//            }
//        }
//        return mulArray
//    }
    
    func getNSArrayForKey(key: String) -> NSArray {
        return UserDefaults.standard.object(forKey: key) as! NSArray
    }
    
    func cacheString(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getStringForKey(key: String) -> String {
        return UserDefaults.standard.object(forKey: key) as! String
    }
    
    func removeCacheForKey(key: String) {
        UserDefaults.standard.set(nil, forKey: key)
    }
    
    
    /// NSKeyedUnarchiver
    ///
    /// - Parameter string: string description
    /// - Returns: return value description
    func cacheArchivePath(string: String) -> String {
        let path = ARCHIVE_PATH! + "/UserAccountInfo"
        let isSuccess : Bool = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        print(isSuccess)
        return path.appending("/" + string + ".archive")
    }
    
    func getArchiveUser() -> User {
        return NSKeyedUnarchiver.unarchiveObject(withFile: cacheArchivePath(string: "CurrentUser")) as! User
    }
    
    func cacheArchiveUser(user: User) -> Bool {
        var isSuccess = false
        if user.userID != nil {
            isSuccess = NSKeyedArchiver.archiveRootObject(user, toFile: cacheArchivePath(string: "CurrentUser"))
        }
        return isSuccess
    }
    
    func getArchiveAccount() -> Account {
        return NSKeyedUnarchiver.unarchiveObject(withFile: cacheArchivePath(string: "CurrentAccount")) as! Account
    }
    
    func cacheArchiveAccount(account: Account) -> Bool {
        var isSuccess = false
        if account.isKind(of: NSObject.self) {
            isSuccess = NSKeyedArchiver.archiveRootObject(account, toFile: cacheArchivePath(string: "CurrentAccount"))
        }
        return isSuccess
    }


}

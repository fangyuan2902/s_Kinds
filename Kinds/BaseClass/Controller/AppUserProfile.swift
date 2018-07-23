//
//  AppUserProfile.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/25.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

class AppUserProfile: NSObject {
    
    let isLogin: Bool? = false
    let __sid: String? = nil
    let userId: String? = nil
    
    static let shareInstance: AppUserProfile = {
        let profile = AppUserProfile()
        return profile
    }()
    
}

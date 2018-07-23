//
//  SubFinancialFactory.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

enum SubType {
    case SubTypeRecommend    // 推荐
    case SubTypeCategory     // 分类
    case SubTypeUnkown       // 未知
}

class SubFinancialFactory: NSObject {
    // MARK:- 生成子控制器
    class func subFindVcWith(identifier: String ) -> BaseViewController {
        var controller: BaseViewController!
        if identifier == "12" {
            controller = FinanceBondListViewController()
        } else if identifier == "1212" {
            controller = FinanceSellOffListViewController()
        } else {
            controller = FinanceListViewController()
        }
        return controller
    }
    
}


//
//  Header.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

public enum AppState {
    case active
    case inactive
    case background
    case terminated
}

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let scanleText = ScreenWidth/375
let BannerHeight = ScreenWidth * 0.52
//适配iPhoneX
let IsIPhoneX = (ScreenWidth == 375.0 && ScreenHeight == 812.0 ? true : false)
let NavibarH: CGFloat = IsIPhoneX ? 88.0 : 64.0
let TabbarH: CGFloat = IsIPhoneX ? 49.0+34.0 : 49.0
let StatusbarH: CGFloat = IsIPhoneX ? 44.0 : 20.0
let IPhoneXBottomH: CGFloat = 34.0
let IPhoneXTopH: CGFloat = 24.0

let appSecret = ""
let appKey = ""

let host_url = ""
let AppImageServerUrl = ""


func kColor(R: CGFloat, G: CGFloat, B: CGFloat) -> UIColor {
    return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1)
}

let AppMainColor = UIColor.hexColor(0xf94a0f, alpha: 1.0)
let PlaceholderTextColor = UIColor.hexColor(0xcccccc, alpha: 1.0)
let EmphasisSubTextColor = UIColor.hexColor(0x333333, alpha: 1.0)
let SecondaryTextColor = UIColor.hexColor(0x999999, alpha: 1.0)
let ViewBackgroundColor = UIColor.hexColor(0xf5f5f5, alpha: 1.0)
let SeparatorColor = UIColor.hexColor(0xdddddd, alpha: 1.0)
let NavigationTextColor = UIColor.hexColor(0x666666, alpha: 1.0)
let GeneralBColor = UIColor.hexColor(0x4ABE89, alpha: 1.0)
let GeneralAColor = UIColor.hexColor(0x48AFFB, alpha: 1.0)
let TrackTintColor = UIColor.hexColor(0xf2f4f8, alpha: 1.0)


//按钮颜色
let App_NormalButton_Color = UIColor.hexColor(0xf94a0f, alpha: 1.0)
//按钮点击时颜色
let App_HighlightedButton_Color = UIColor.hexColor(0xf94a0f, alpha: 1.0)
//按钮不可点击颜色
let App_DisableButton_Color = UIColor.hexColor(0xcccccc, alpha: 1.0)

// NSUserDefault
let uDefault = UserDefaults.standard

// 文字大小适配
func f(num: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: num)
}

func fAndN(num: CGFloat, fontName: String) -> UIFont {
    let temp = UIFont.init(name: fontName, size: num)
    if let t = temp {
        return t
    } else {
        return f(num: num)
    }
}

func fb(num: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: num)
}





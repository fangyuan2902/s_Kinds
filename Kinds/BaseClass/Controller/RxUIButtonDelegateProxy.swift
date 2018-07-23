//
//  RxUIButtonDelegateProxy.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/25.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    /*
     button isEnable与否的两种情况下对应的 backgroudColor
     */
    
    public var isEnabledBgColor: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { control, value in
            
            control.backgroundColor = value ? UIColor.blue : UIColor.white
        }
    }
    
    
    /*
     button isEnable与否的两种情况下对应的 borderColor
     */
    
    public var isEnabledBorderColor: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { control, value in
            
            control.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.white.cgColor
            control.layer.masksToBounds = true
            
        }
    }
}


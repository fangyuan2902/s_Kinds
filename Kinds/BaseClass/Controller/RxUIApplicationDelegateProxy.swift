//
//  RxUIApplicationDelegateProxy.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/25.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, UIApplicationDelegate, DelegateProxyType {
    
    public weak private(set) var application: UIApplication?
    
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxUIApplicationDelegateProxy(application: $0) }
    }
    
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?,
                                          to object: UIApplication) {
        object.delegate = delegate
    }
    
    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?,
                                            retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }

}

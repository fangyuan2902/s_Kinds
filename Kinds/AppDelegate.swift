//
//  AppDelegate.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootTabbar = RootTabbarViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = rootTabbar
        
        window?.makeKeyAndVisible();
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//扩展
extension UIApplicationState {
    //将其转为我们自定义的应用状态枚举
    func toAppState() -> AppState {
        switch self {
        case .active:
            return .active
        case .inactive:
            return .inactive
        case .background:
            return .background
        }
    }
}

//UIApplication的Rx扩展
extension Reactive where Base: UIApplication {
    
    //代理委托
    var delegate: DelegateProxy<UIApplication, UIApplicationDelegate> {
        return RxUIApplicationDelegateProxy.proxy(for: base)
    }
    
    //应用重新回到活动状态
    var didBecomeActive: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map{ _ in return .active}
    }
    
    //应用从活动状态进入非活动状态
    var willResignActive: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map{ _ in return .inactive}
    }
    
    //应用从后台恢复至前台（还不是活动状态）
    var willEnterForeground: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
            .map{ _ in return .inactive}
    }
    
    //应用进入到后台
    var didEnterBackground: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map{ _ in return .background}
    }
    
    //应用终止
    var willTerminate: Observable<AppState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map{ _ in return .terminated}
    }
    
    //应用各状态变换序列
    var state: Observable<AppState> {
        return Observable.of(
            didBecomeActive,
            willResignActive,
            willEnterForeground,
            didEnterBackground,
            willTerminate
            )
            .merge()
            .startWith(base.applicationState.toAppState()) //为了让开始订阅时就能获取到当前状态
    }
}




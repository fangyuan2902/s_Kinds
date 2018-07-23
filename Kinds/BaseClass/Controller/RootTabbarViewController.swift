//
//  RootTabbarViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

class RootTabbarViewController: UITabBarController {

    var currentIndex : NSInteger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 通过 appearance统一设置UITabBarItem的文字属性，属性后面带UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
        let tabBar = UITabBarItem.appearance()
        let attrs_Normal = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.gray]
        let attrs_Select = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        tabBar.setTitleTextAttributes(attrs_Normal, for: .normal)
        tabBar.setTitleTextAttributes(attrs_Select, for: .selected)
        
        currentIndex = 0
        
        setupUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RootTabbarViewController : UITabBarControllerDelegate {
    fileprivate func setupUI() {
        
        self.delegate = self

        AddchildS(VC: HomePageViewController(), title: "首页", image: "tab_home_n", selectIameg: "tab_home_s")
        AddchildS(VC: FinancialViewController(), title: "投资", image: "tab_product_n", selectIameg: "tab_product_s")
        AddchildS(VC: AccountViewController(), title: "资产", image: "tab_asset_n", selectIameg: "tab_asset_s")
        AddchildS(VC: UserInfoViewController(), title: "我", image: "tab_me_n", selectIameg: "tab_me_s")
    }
    
    func AddchildS(VC:BaseViewController , title :String ,image :String ,selectIameg :String) {
        /// 加上导航控制器
        let nav : BaseNavgationViewController = BaseNavgationViewController(rootViewController: VC)
        nav.tabBarItem = UITabBarItem(title: title, image:UIImage(named:image), selectedImage: UIImage(named:selectIameg))
        addChildViewController(nav)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {        
        if self.selectedIndex == 2 {
            self.selectedIndex = currentIndex!
            return;
        }
        currentIndex = self.selectedIndex
        print("\(viewController)")
    }
    
}


//
//  BaseNavgationViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

protocol navProtocol:class {
    func backItem()
    func rightBtnClick(isWebCreat:Bool)
}

class BaseNavgationViewController: UINavigationController , UIGestureRecognizerDelegate {
    
    weak var delegates: navProtocol?
    var  isWebCreat:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        //关闭导航栏半透明效果
        self.navigationController?.navigationBar.isTranslucent = false
        //侧滑返回
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.interactivePopGestureRecognizer) {
            //只有二级以及以下的页面允许手势返回
            if self.navigationController!.viewControllers.count > 1 {
                return true
            }
            return false
        }
        return true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
    }
    
//    // 重写导航栏push方法  。。。去设置所有的导航栏按钮为统一样式
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    
//        if #available(iOS 11.0, *) {
//            if ScreenHeight == 812 {
//                let rootView = viewController.view
//                rootView?.frame = CGRect(x: (rootView?.safeAreaInsets.left)!, y: (rootView?.safeAreaInsets.top)!, width: ScreenWidth - (rootView?.safeAreaInsets.left)! - (rootView?.safeAreaInsets.right)!, height: ScreenHeight - (rootView?.safeAreaInsets.bottom)!)
//            }
//        }
        
//        if self.childViewControllers.count > 0 {
//            let  but = UIButton(type: .custom)
//            but .setTitle("返回", for: .normal)
//            but .setTitleColor(UIColor.black, for: .normal)
//            but .setTitleColor(UIColor.red, for: .highlighted)
//            but.sizeToFit()
//            but.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
//            but.addTarget(self, action:  Selector(("Back")), for: .touchUpInside)
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: but)
//        }
    
//        super.pushViewController(viewController, animated: true)
//    }
    
    
    func Back() {
        self .popViewController(animated: true)
    }
    
    //添加左边按钮
    func addLeftBtn(image:UIImage?,title:String){
        let leftBtn = UIButton(type:.system)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if image != nil {
            //创建左边按钮
            leftBtn.setImage(image, for: .normal)
        } else {
            //创建左边按钮
            leftBtn.setTitle(title, for: .normal)
            leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*scanleText)
        }
        leftBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        let btn = UIBarButtonItem(customView: leftBtn)
        //设置导航项左边的按钮
        navigationItem.setLeftBarButton(btn, animated: true)
    }
    
    @objc private func leftClick(){
        delegates?.backItem()
    }
    
    //添加右边按钮
    func addRightBtn(image:UIImage?,title:String,isWebCreat:Bool){
        self.isWebCreat = isWebCreat
        let rightBtn = UIButton(type:.system)
        if image != nil {
            //创建右边按钮
            rightBtn.setImage(image, for: .normal)
        } else {
            //创建右边按钮
            rightBtn.setTitle(title, for: .normal)
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15*scanleText)
        }
        rightBtn.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        let btn = UIBarButtonItem(customView: rightBtn)
        //设置导航项右边的按钮
        navigationItem.setRightBarButton(btn, animated: true)
    }
    
    @objc private func rightClick(){
        delegates?.rightBtnClick(isWebCreat: self.isWebCreat!)
    }
    
    //点击空白处收起键盘
    func clickEmptyHiddenKeyboard(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(tap:)))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewClick(tap:UITapGestureRecognizer){
        tap.view?.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

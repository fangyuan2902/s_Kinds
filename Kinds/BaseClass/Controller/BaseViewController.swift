//
//  BaseViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
//import MJExtension
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.all
        self.edgesForExtendedLayout = []
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        addLeftButton(image: UIImage.init(named: "nav_back")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setLeftButtonHidden() {
        UINavigationItem().leftBarButtonItem = nil
    }
    
    func addLeftButton(image: UIImage) {//使用!号不需要再解包
        let leftBtn = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action:#selector(goBack))
        leftBtn.width = 32
//        navigationItem.leftBarButtonItem = leftBtn
        navigationItem.setLeftBarButton(leftBtn, animated: true)
    }
    
    @objc func goBack() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController!.popViewController(animated: true)
        } else {
            if (self.navigationController != nil) {
                self.navigationController!.dismiss(animated: true, completion: nil)
            } else {
                self .dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func goBackRoot() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController!.popToRootViewController(animated: true)
        } else {
            if (self.navigationController != nil) {
                self.navigationController!.dismiss(animated: true, completion: nil)
            } else {
                self .dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func goBackPresent() {
        if (self.navigationController != nil) {
            self.navigationController!.dismiss(animated: true, completion: nil)
        } else {
            self .dismiss(animated: true, completion: nil)
        }
    }
    
    func presentLoginVC() {
        let vc = LoginViewController()
        let nav = BaseNavgationViewController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func pushWebViewController(url: String, prama: Dictionary<String, Any>) {
        let webVC: SingleWebViewController = SingleWebViewController()
        if url.contains("http") {
            webVC.url = url
        } else {
            webVC.url = host_url + url
        }
        webVC.prama = appServiceBodyArgumentsAttach(sourceBody: prama)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(webVC, animated: true)
    }
    
    func present(_ viewControllerToPresent: UIViewController) {
        self.navigationController!.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewController {
    func showAlter(title: String, message: String, cancle: String, sure: String, sureHandle:@escaping() -> (),  cancelHandle:@escaping() -> ()) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        if cancle.count > 0 {
            let cancelAction = UIAlertAction(title: cancle, style: .cancel, handler: {
                action in
                cancelHandle()
            })
            alertController.addAction(cancelAction)
        }
        if sure.count > 0 {
            let okAction = UIAlertAction(title: sure, style: .default, handler: {
                action in
                sureHandle()
            })
            alertController.addAction(okAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

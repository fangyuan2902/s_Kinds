//
//  FinancialViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

// MARK:- 全局变量 - 当前navigationController
var naviController: BaseNavgationViewController?

class FinancialViewController: BaseViewController {

    // MARK:- 懒加载属性
    /// 子标题
    lazy var subTitleArr:[String] = {
        return ["推荐", "分类", "111"]
    }()
    
    /// 子控制器
    lazy var controllers: [BaseViewController] = { [unowned self] in
        var cons: [BaseViewController] = [BaseViewController]()
        for title in self.subTitleArr {
            let con = SubFinancialFactory.subFindVcWith(identifier: title)
            cons.append(con)
        }
        return cons
        }()
    
    /// 子标题视图
    lazy var subTitleView: SubTitleView = { [unowned self] in
        let subTitleView = SubTitleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        self.view.addSubview(subTitleView)
        return subTitleView
        }()
    
    /// 控制多个子控制器
    lazy var lxfPageVc: PageViewController = {
        let pageVc = PageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self
        self.view.addSubview(pageVc.view)
        return pageVc
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.0)
        title = "投资"
        
        subTitleView.delegate = self
        subTitleView.titleArray = subTitleArr
        // 配置子标题视图
        configSubViews()
        
        naviController = navigationController as? BaseNavgationViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- LXFPageViewController代理
extension FinancialViewController: PageViewControllerDelegate {
    func lxfPageCurrentSubControllerIndex(index: NSInteger, pageViewController: PageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- 配置子标题视图
extension FinancialViewController {
    func configSubViews() {
        lxfPageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

// MARK:- LXFFindSubTitleViewDelegate
extension FinancialViewController: SubTitleViewDelegate {
    func findSubTitleViewDidSelected(_ titleView: SubTitleView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        lxfPageVc.setCurrentSubControllerWith(index: atIndex)
    }
}



//
//  HomePageViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomePageViewController: BaseViewController, AlertViewDelegate, UITableViewDelegate, UITableViewDataSource, BannerScrollViewDelegate, UIScrollViewDelegate, HomePageNiceDelegate {
    
    var tableView: UITableView!

    var models = [1,2,3,4]
    
    var bbannerView: BannerScrollView!
    
    var viewModel : HomePageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        
        self.viewModel = HomePageViewModel.init()
        
        _setUpNavigationBar()
        _setupUI()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        _ = self.tableView?.setUpHeaderRefresh({ [weak self] in
            delay(1.0, closure: {
                self?.models = (self?.models.map({_ in self?.random100()}))! as! [Int]
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing(.success,delay: 0.5)
            });
        })
        _ = self.tableView?.setUpFooterRefresh({ [weak self] in
            delay(1.5, closure: {
                self?.models.append((self?.random100())!)
                self?.tableView.reloadData()
                if (self?.models.count)! < 15 {
                    self?.tableView.endFooterRefreshing()
                }else{
                    self?.tableView.endFooterRefreshingWithNoMoreData()
                }
            })
            delay(1.0, closure: {
                self?.tableView?.endFooterRefreshing()
            });
        })
        
        
        self.bbannerView = BannerScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: BannerHeight))
        self.bbannerView.delegate = self
        let bview: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: BannerHeight))
        bview.addSubview(self.bbannerView)
        self.tableView.tableHeaderView = bview
        
        self.viewModel.postBanner()
        
        self.viewModel.POST_Request { (result) in
            self.bbannerView.setImages(images: self.viewModel.bannerArr)
        }
        
        //应用重新回到活动状态
        UIApplication.shared.rx
            .state
            .subscribe(onNext: { state in
                switch state {
                case .active:
                    print("应用进入活动状态。")
                case .inactive:
                    print("应用进入非活动状态。")
                case .background:
                    print("应用进入到后台。")
                case .terminated:
                    print("应用终止。")
                }
            })
            .disposed(by: disposeBag)
        
        //应用重新回到活动状态
        UIApplication.shared.rx
            .didBecomeActive
            .subscribe(onNext: { _ in
                print("应用进入活动状态。")
            })
            .disposed(by: disposeBag)
        
        //应用从活动状态进入非活动状态
        UIApplication.shared.rx
            .willResignActive
            .subscribe(onNext: { _ in
                print("应用从活动状态进入非活动状态。")
            })
            .disposed(by: disposeBag)
        
        //应用从后台恢复至前台（还不是活动状态）
        UIApplication.shared.rx
            .willEnterForeground
            .subscribe(onNext: { _ in
                print("应用从后台恢复至前台（还不是活动状态）。")
            })
            .disposed(by: disposeBag)
        
        //应用进入到后台
        UIApplication.shared.rx
            .didEnterBackground
            .subscribe(onNext: { _ in
                print("应用进入到后台。")
            })
            .disposed(by: disposeBag)
        
        //应用终止
        UIApplication.shared.rx
            .willTerminate
            .subscribe(onNext: { _ in
                print("应用终止。")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 80;
        } else if (indexPath.section == 1) {
            return 120;
        } else {
            return 192;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.leastNormalMagnitude
        } else if (section == 1) {
            return 10
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
//        if (section < 2) {
//            return nil
//        } else {
//            let hfView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
//
//            let sectionHeader: HomeTabTableSectionHeaderView = Bundle.main.loadNibNamed("HomeTabTableSectionHeaderView", owner: self, options: nil)?.first as! HomeTabTableSectionHeaderView
//            sectionHeader.addTarget(target: self, action: #selector(buttonSectionAction))
//            hfView.addSubview(sectionHeader)
//            sectionHeader.setData(title: "12345", detailTitle: "56789", indexSection: section)
//
//            return hfView;
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell: HomePageNiceTableViewCell = HomePageNiceTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "HomePageNiceTableViewCell")
            cell.delegate = self
            
            cell.setDataWithArray(array: self.viewModel.niceArr)
            
            return cell

        }
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
        
        return cell
//        if indexPath.section == 0 {
//            let cell: HomeTabNineTableViewCell = HomeTabNineTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "HomeTabNineTableViewCell")
//            let model: IndexEntrance = IndexEntrance.init()
//            model.icon = "12345"
//            model.text = "12345"
//            model.subTitle = "12345"
//            model.functionType = "12345"
//
//            cell.setDataFormArray(array: [model])
//
//            return cell
//        } else if indexPath.section == 1 {
//            let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
//
//            return cell
//        } else {
//            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//            if cell == nil {
//                cell = Bundle.main.loadNibNamed("HomeTabTableViewCell", owner: self, options: nil)?.first as! HomeTabTableViewCell?
//            }
//            cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
//
//            return cell!
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func homeDidSelectItemIndex(index:NSInteger) {
        switch index {
        case 0:
            print(index)
            pushWebViewController(url: PlatformData, prama: [ : ])
        case 1:
            print(index)
            pushWebViewController(url: InformationIndex, prama: [ : ])
        case 2:
            print(index)
            if AppUserProfile.shareInstance.isLogin == false {
                presentLoginVC()
            } else {
                pushWebViewController(url: ShopIndex, prama: [ : ])
            }
        case 3:
            print(index)
            if AppUserProfile.shareInstance.isLogin == false {
                presentLoginVC()
            } else {
                pushWebViewController(url: Platform, prama: [ : ])
            }
        default:
            print(index)
        }
    }
    
    deinit{
        print("Deinit of DefaultTableViewController")
    }
    
    func buttonSectionAction(button: UIButton) {
        print(button.tag)
    }
    
    func adddd() {
        pushViewController(UIViewController())
    }
    
    func random100()->Int{
        return Int(arc4random()%100)
    }
    
    func clickItem(url: String) {
        pushWebViewController(url: url, prama: ["type":"12345678"])
        print(url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    private func _setUpNavigationBar(){
        self.title = "AlertView"
        
        //设置导航栏背景颜色
        let color = UIColor(red: CGFloat(0) / 255.0, green: CGFloat(191) / 255.0, blue: CGFloat(143) / 255.0, alpha: CGFloat(1))
        navigationController?.navigationBar.barTintColor = color
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(white: 0.871, alpha: 1.000)
        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadow.shadowBlurRadius = 20
        
        //设置导航栏标题颜色
        let attributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18),NSAttributedStringKey.shadow:shadow]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.isTranslucent = false
        
        //设置返回按钮的颜色
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
    }
    
    private func _setupUI(){
        tableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView!)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        let btn = UIButton()
        
        let w:CGFloat = 200
        let h:CGFloat = 60
        let x = (view.frame.size.width - w)/2
        let y = (h+10) * CGFloat(5) + CGFloat(10)
        btn.frame = CGRect(x: x, y: y, width: w, height: h)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("样式 "+"\(3+1)", for: .normal)
        btn.addTarget(self, action: #selector(onBtn(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        
    }
    
    // MARK: - Action
    @objc func onBtn(sender:UIButton){
        
        let alertV = AlertView(title: "AlertView", message: "取消模糊背景\n消息好长啊啊啊消息好长啊啊啊消息好长啊啊啊消息好长啊啊啊消息好长啊啊啊消息好长啊啊啊", delegate: self as AlertViewDelegate, cancelButtonTitle: "取消", otherButtonTitles: ["确定"])
        alertV.visual = false
        alertV.show()
    }
}

// Mark: AlertViewDelegate
extension HomePageViewController {
    func alertView(alertView: AlertView, clickedButtonAtIndex: Int) {
        print("点击下标是:\(clickedButtonAtIndex)")
    }
}


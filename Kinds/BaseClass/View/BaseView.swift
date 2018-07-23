//
//  BaseView.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import MJRefresh

class BaseView: UIView {

    var currentVc = BaseViewController()
    public lazy var ModelMeArr : [BannerModel] = [BannerModel]()
    lazy var TableView:UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(loadData))
        tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadNextData))
        tableView.mj_footer = footer
        return tableView
    }()
    // 下拉刷新
    /*
     这里之所以用objc func 是用到了OC 的一些东西，具体的我也没有整明白，
     */
    @objc func loadData()  {
//        currentVc.loadData(pageNumber: currentVc.pageNumber, pageSize: currentVc.pageSize)
        TableView.mj_header.endRefreshing()
        
        self.TableView.reloadData()
    }
    
    //上拉加载
    @objc func loadNextData() {
        
        let pageNub : Int = 1
//        currentVc.loadData(pageNumber:String(pageNub+1), pageSize: currentVc.pageSize)
        
        self.TableView.reloadData()
    }
    
    init(frame: CGRect , currentVC:BaseViewController , modelArr:[BannerModel]) {
        super.init(frame: frame)
        self.ModelMeArr = modelArr
        currentVc = currentVC
        installUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func installUI() {
        // 配合下文自动适配Cell行高
        TableView.estimatedRowHeight = 44.0
        self.registerCell()
        self.TableView.delegate = self;
        self.TableView.dataSource = self;
        addSubview(self.TableView)
    }
    
    func registerCell() {
        self.TableView.register(UINib.init(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
    }
}

extension BaseView : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("UITableViewCell", owner: self, options: nil)?.last as? UITableViewCell
        }
        cell?.textLabel?.text = self.ModelMeArr[indexPath.row].title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.ModelMeArr.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("别点了，没又详情")
    }
    // 这么写有点粗，非常影响性能。 待修改！
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}



//
//  HomePageViewModel.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
//import RxCocoa
import RxAlamofire

class HomePageViewModel: NSObject {

    let disposeBag = DisposeBag()
    lazy var bannerArr : [BannerModel] = [BannerModel]()
    lazy var niceArr : [NiceViewModel] = [NiceViewModel]()
    
    override init() {
        super.init()
        
        let model : NiceViewModel = NiceViewModel()
        model.title = "平台数据"
        model.picPath = "home_icon_reserve"
        model.url = ""
        
        let model1 : NiceViewModel = NiceViewModel()
        model1.title = "信息披露"
        model1.picPath = "home_icon_data"
        model1.url = ""
        
        let model2 : NiceViewModel = NiceViewModel()
        model2.title = "积分商城"
        model2.picPath = "home_icon_safety"
        model2.url = ""
        
        let model3 : NiceViewModel = NiceViewModel()
        model3.title = "公告"
        model3.picPath = "home_icon_invitation"
        model3.url = ""
        
        self.niceArr.removeAll()
        self.niceArr.append(model)
        self.niceArr.append(model1)
        self.niceArr.append(model2)
        self.niceArr.append(model3)
    }
    
    func postBanner() {
        let urlString = baseURLWithPath(urlString: BannerList)
        let url = URL(string:urlString)!
        
        //创建并发起请求
        requestData(.post, url, parameters: appServiceBodyArgumentsAttach(sourceBody: [:])).subscribe(onNext: {
            response, data in
            //判断响应结果状态码
            if 200 ..< 300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    as! [String: Any]
                guard let resultDict = json as? [String : NSObject] else { return }
                let response = Response().insertDic(dic: resultDict)
                if response.code == 0x9999 {
                    print("请求成功")
                    
                } else {
                    
                }
                print("请求成功！返回的数据是：", str ?? "")
            }else{
                print("请求失败！")
            }
        }).disposed(by: disposeBag)
    }
    
    func POST_Request(finishedCallback :  @escaping (Any) -> ()) {
        APINetworkTools.shareInstance.requestData(urlString: BannerList, finishedCallback: { (response) in
            self.bannerArr.removeAll()
            print(response.data)
            let dictionary : Dictionary = response.data as! Dictionary<String, Any>
            
            guard let dataArr = dictionary["list"] as? [NSObject]
                else {
                    return
            }
            for dic in dataArr {
                let jsonString = toJSONString(dict: dic as! NSDictionary) as String
                var model : BannerModel
                do {
                    model = try JSONDecoder().decode(BannerModel.self, from: jsonString.data(using: .utf8)!)
                    self.bannerArr.append(model)
                } catch {
                    // 异常处理
                    finishedCallback(response.msg)
                    print("解析失败")
                }
            }
            finishedCallback("")

        }) { (code, string) in
            if string == nil {
                finishedCallback("")
            } else {
                finishedCallback(string!)
            }
        }
        
    }
}

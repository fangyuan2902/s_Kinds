//
//  APIDemo.swift
//  Kinds
//
//  Created by kangzf on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIDemo: NSObject {
    let host_url = "https://www.17money.test/jjjr2-mobile-gateway"       //请求地址
    let top      = "/open/v311/getBanner"                                 // 参数：头条
    let appkey = "ad2908cae6020addf38ffdb5e2255c06"    // 应用 appkey
    
    let main_url = "https://httpbin.org/get"
    
    let parameters : [String : Any] = ["type": "1","device": ["os": "10.2","t": "1","v": "1.0.1"]]
    lazy var ModelMeArr : [BannerModel] = [BannerModel]()
    
    let selfSignedHosts = ["www.17money.test", "www.hangge.com"]
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    func POST_Request() {
        
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust
                && self.selfSignedHosts.contains(challenge.protectionSpace.host) {
                print("服务器认证！")
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                return (.useCredential, credential)
            } else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
        
        //request(host_url, method:.post, parameters : parameters)
        //        let urlstring = "\(host_url)type=\(top)&key=\(appkey)"
        let urlstring = host_url + top
        
        APIFactory.requestData(URLString: urlstring, dynamicParameters: parameters) { (modelArr) in
            //            self.ModelMeArr = modelArr
        }
        
        Alamofire.request(urlstring, method:.post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/JSON"]).responseJSON { (response) in
            print("POST_Request --> post 请求 --> returnResult = \(response)")
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    //                    success(value)
                    let json = JSON(value)
                    print("\(json)")
                }
            case .failure(let error):
                //                failture(error)
                print("error:\(error)")
            }
        }
        
        Alamofire.request(urlstring, method:.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (returnResult) in
            print("POST_Request --> post 请求 --> returnResult = \(returnResult)")
            switch returnResult.result.isSuccess {
            case true:
                print("数据获取成功!")
            case false:
                print(returnResult.result.error ?? Error.self)
            }
        }
    }
}


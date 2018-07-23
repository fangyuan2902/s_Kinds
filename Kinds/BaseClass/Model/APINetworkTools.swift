//
//  APINetworkTools.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APINetworkTools: NSObject {
    
//    let parameters : [String : Any] = ["type": "1", "device": ["os": "10.2", "t": "1", "v": "1.0.1"]]
    let selfSignedHosts = ["www.17money.test", "www.17money.pre", "www.17money.com"]
//    let headers: HTTPHeaders = ["Content-Type": "application/json","Accept": "application/json", "UserAgent":"iPhone" , "User-Agent":"iPhone"]
    let headers: HTTPHeaders = ["Accept": "application/json", "UserAgent":"iPhone" , "User-Agent":"iPhone"]

    static let shareInstance: APINetworkTools = {
        let tools = APINetworkTools()
        tools.sessionDidChallenge()
        return tools
    }()
    
    func sessionDidChallenge() -> () {
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
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
    }
}

extension APINetworkTools {
    func requestData(urlString : String, parameters : Dictionary<String, Any>? = nil, finishedCallback :  @escaping (Response) -> (), failureCallback :  @escaping (NSInteger?, String?) -> ()) {
        UserDefaults.standard.register(defaults: ["UserAgent":"iPhone" , "User-Agent":"iPhone"])
        let parameter = NSMutableDictionary()
        if (parameters != nil) {
//            parameter.setDictionary(parameters!)
            parameter.addEntries(from: parameters!)
        }
        parameter.addEntries(from: appServiceBodyArgumentsAttach(sourceBody: [:]))
//        parameter.setDictionary(appServiceBodyArgumentsAttach(sourceBody: [:]))
        print(parameter)
        let para : Dictionary<String, Any> = parameter as! Dictionary
        
        
        let url = baseURLWithPath(urlString: urlString)
        
        Alamofire.request(url, method: .post, parameters: para, headers: headers).responseJSON { (responseResult) in
            switch responseResult.result.isSuccess {
            case true:
                print("数据获取成功!")
                guard let resResult = responseResult.result.value else {return}
                guard let resultDict = resResult as? [String : NSObject] else { return }
                let response = Response().insertDic(dic: resultDict)
                if response.code == 0x9999 {
                    print("请求成功")
                    finishedCallback(response)
                } else {
                    failureCallback(response.code, response.msg)
                }
            case false:
                print("服务器请求错误!" + url)
                print(responseResult.result.error ?? Error.self)
                failureCallback(0, responseResult.result.error as? String)
            }
        }
    }
}

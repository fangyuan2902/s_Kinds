//
//  NetworkTools.swift
//  Kinds
//
//  Created by kangzf on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType : NSInteger {
    case GET
    case POST
}

class NetworkTools: NSObject {
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        return tools
    }()
}

extension NetworkTools {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (Response) -> ()){
        // 1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            // 3.获取结果
            guard let result = response.result.value else {return}
            guard let resultDict = result as? [String : NSObject] else { return }
            let response = Response().insertDic(dic: resultDict)
            if response.code == "C_000" {
                print("请求成功")
            }else{
                print("服务器请求错误!")
            }
            // 4.将结果回调出去
            finishedCallback(response)
        }
    }
    
    // MARK: 请求JSON数据
    func requestData(methodType: MethodType, urlString: String, parameters: [String : AnyObject]?, finished:@escaping (_ result: AnyObject?, _ error: NSError?) -> ()) {
        
        // 1.定义请求结果回调闭包
        let resultCallBack = { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                finished(response.result.value as AnyObject?, nil)
            } else {
                finished(nil, response.result.error as NSError?)
            }
        }
        
        // 2.请求数据
        let httpMethod: HTTPMethod = methodType == .GET ? .get : .post
        request(urlString, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: resultCallBack)
    }
}



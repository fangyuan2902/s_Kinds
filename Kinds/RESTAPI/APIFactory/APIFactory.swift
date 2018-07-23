//
//  APIFactory.swift
//  Kinds
//
//  Created by kangzf on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

var pageNumber = "1"
var pageSize = "10"
var ModelMeArr : [joke] = [joke]()

class APIFactory: NSObject{
    /*这个方法是在外界调用，  我们把一些固定的不要修改的参数放到这里，然后通过这个方法我们可以传入一个动态的字典，这个动态字典是存放外界传过来的参数，这样代码看起来会跟整洁*/
    class func requestData(URLString : String, dynamicParameters : [String : Any]? = nil, finishedCallback :  @escaping ([joke]) -> ()){
        var dic = [String:String]()
        for (key, value) in dynamicParameters! {
            dic[key] = value as? String
        }
        dic.updateValue(getTimeChuo(), forKey: "time")
        dic.updateValue(myKey, forKey: "key")
        
        NetworkTools.requestData(.GET, URLString: URLString, parameters: dic) { (response) in
            
            guard let dic = response.data as? [String : NSObject] else {return}
            guard let dataArr = dic["data"] as? [NSObject] else {return}
            for dic in dataArr{
                let jsonString = toJSONString(dict: dic as! NSDictionary) as String
                var xiaomin : joke
                do {
                    xiaomin = try JSONDecoder().decode(joke.self, from: jsonString.data(using: .utf8)!)
                    ModelMeArr.append(xiaomin)
                    print(xiaomin.content)
                } catch {
                    // 异常处理
                    print("解析失败")
                }
            }
            finishedCallback(ModelMeArr)
        }
        
    }
}




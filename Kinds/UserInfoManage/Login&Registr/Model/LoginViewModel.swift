//
//  LoginViewModel.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/26.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//struct Login {
//    let loginName = Variable("")
//    let loginPwd = Variable("")
//
//    lazy var nameInfo = {
//        return self.loginName.asObservable()
//            .map{$0}
//            .share(replay: 1)
//    }()
//}

class LoginViewModel: NSObject {

//    var loginName: String?
//    var loginPwd: String?
    let loginName = Variable("")
    let loginPwd = Variable("")
    
    lazy var nameInfo = {
        return self.loginName.asObservable()
            .map{$0}
            .share(replay: 1)
    }()
    
    
    func POST_Request(finishedCallback :  @escaping (Any) -> ()) {
        let parameter = NSMutableDictionary()
        parameter.setValue(loginName.value, forKey: "loginName")
        parameter.setValue(base64Encoding(plainString: loginPwd.value), forKey: "loginPwd")
        APINetworkTools.shareInstance.requestData(urlString: UserDoLogin, parameters : parameter as! Dictionary<String, Any>, finishedCallback: { (response) in
            print(response.data)
            let dictionary : Dictionary = response.data as! Dictionary<String, Any>
            
//            guard let dataArr = dictionary["list"] as? [NSObject]
//                else {
//                    return
//            }
            finishedCallback(response.msg)
            
        }) { (code, string) in
            if string == nil {
                finishedCallback("")
            } else {
                finishedCallback(string!)
            }
        }
        
    }
    
}

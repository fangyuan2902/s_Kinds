//
//  Response.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import Foundation

//typealias ResponseSuccessResult = (Response) -> ()
//typealias ResponseSuccessArray = ([NSObject]) -> ()
//typealias ResponseSuccessDictionary = ([String : NSObject]) -> ()
//typealias ResponseFailure = (NSError) -> ()
//typealias ResponseFail = (NSError,String) -> ()

class Response: NSObject {
    var code : NSInteger!
    var msg : String!
    var data : AnyObject!
    
    
    
    func insertDic(dic:[String : NSObject]) -> Response {
        let code : NSInteger = dic["resCode"] as! NSInteger
        let reason : String = dic["resMsg"] as! String
        let result : AnyObject = dic["resData"] as AnyObject
        return initResponse(errorCode: code, jsonReason: reason, jsonResult: result)
    }
    
    func initResponse(errorCode : NSInteger , jsonReason : String , jsonResult : AnyObject) -> Response {
        code = errorCode
        msg = jsonReason
        data = jsonResult
        return self
    }
}



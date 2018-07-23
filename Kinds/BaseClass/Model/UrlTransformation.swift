//
//  UrlTransformation.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

func baseURLWithPath(urlString : String) -> String {
    var url = urlString
    if urlString.contains("http") == false {
        url = host_url + urlString
    }
    return url
}

func baseImageURLWithPath(urlString : String) -> String {
    var url = urlString
    if urlString.contains("http") == false {
        url = AppImageServerUrl + urlString
    }
    return url
}

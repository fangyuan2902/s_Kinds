//
//  Data-Extenstion.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

extension Data {
    public init(hex: String) {
        self.init(bytes: Array<UInt8>(hex: hex))
    }
    
    public var bytes: Array<UInt8> {
        return Array(self)
    }
    
    public func toHexString() -> String {
        return bytes.toHexString()
    }
}


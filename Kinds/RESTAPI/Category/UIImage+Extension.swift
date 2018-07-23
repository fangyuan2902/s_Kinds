//
//  UIImage-Extension.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/25.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

extension UIImage {

    class func createImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
    
}

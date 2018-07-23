//
//  NavigationBar-Extension.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/20.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func RXSetBackgroundColor(color:UIColor) {
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*1.2, height: 100)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(image, for: .default)
    }
}


//
//  CenterButton.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/22.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

class CenterButton: UIButton {
    
    var image : UIImageView?
    var title : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUIView()
    }
    
    func createUIView() {
        self.image = UIImageView()
        self.image?.frame = CGRect(x: CGFloat((self.frame.size.width - 40) / 2), y: 0, width: 40 , height: 40 )
        self.image?.centerY = self.centerY - 25
        self.addSubview(self.image!)
        
        self.title = UILabel()
        self.title?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: 20 )
        self.title?.textColor = UIColor.black
        self.title?.textAlignment = NSTextAlignment.center
        self.title?.centerY = self.centerY + 10
        self.addSubview(self.title!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        self.image?.image = image
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        self.title?.text = title
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        self.title?.textColor = color
    }
    
    func setFont(font: UIFont) {
        self.title?.font = font
    }

}

//
//  UIButton-Extension.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/22.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setNormalBackground(normalColor: UIColor, hightedColor: UIColor, disableColor: UIColor) {
        setNormalBackground(normalColor: normalColor)
        setHighlightedBackground(hightedColor: hightedColor)
        setDisableClickBackground(disableColor: disableColor)
    }
    
    func setNormalBackground(normalImg: UIImage, hightedImg: UIImage, disableImg: UIImage) {
        self.setBackgroundImage(normalImg, for: .normal)
        self.setBackgroundImage(hightedImg, for: .highlighted)
        self.setBackgroundImage(disableImg, for: .disabled)
    }
    
    func setNormalBackground(normalColor: UIColor) {
        self.setBackgroundImage(UIImage.createImageWithColor(color: normalColor), for: .normal)
    }
    
    func setHighlightedBackground(hightedColor: UIColor) {
        self.setBackgroundImage(UIImage.createImageWithColor(color: hightedColor), for: .highlighted)
    }
    
    func setDisableClickBackground(disableColor: UIColor) {
        self.setBackgroundImage(UIImage.createImageWithColor(color: disableColor), for: .disabled)
    }
    
    @objc func set(image anImage: UIImage?, title: String, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState) {
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)        
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
}

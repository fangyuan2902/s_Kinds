//
//  GuideView.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

class GuideView: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    var defaultImage: UIImageView?
    var pageControl: UIPageControl?
    var timer: Timer?
    var images: Array<Any>? {
        set{//根据数据创建 对应视图
            self.images = newValue
            if images?.count == 0 {
                return
            }
            
            setScrollView()
            setPageControl()
        }
        get{
            return self.images
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //创建ScrollView
    func setScrollView() {
        if scrollView == nil {
            scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
            scrollView?.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight)
            scrollView?.showsVerticalScrollIndicator = false
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.delegate = self
            scrollView?.bounces = false
            scrollView?.isPagingEnabled = true
            self.addSubview(scrollView!)
            for index in 0...(images?.count)! - 1 {
                let imageView = UIImageView.init(frame: CGRect(x: CGFloat(index) * ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight))
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.image = UIImage.init(named: "bannerImg")
                scrollView?.addSubview(imageView)
            }
        }
    }
    
    //创建PageControl
    func setPageControl() {
        if pageControl == nil {
            pageControl = UIPageControl.init()
            pageControl?.numberOfPages = (images?.count)!
            pageControl?.currentPage = 0
            pageControl?.pageIndicatorTintColor = UIColor.white
            pageControl?.currentPageIndicatorTintColor = UIColor.red
            pageControl?.center = CGPoint(x: ScreenWidth / 2.0, y: (scrollView?.frame.size.height)! - 15)
            self.addSubview(pageControl!)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

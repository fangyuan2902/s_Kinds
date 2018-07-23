//
//  BannerScrollView.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/19.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit

//@objc protocol BannerScrollViewDelegate : NSObjectProtocol {
//    @objc optional func clickItem()
//}
protocol BannerScrollViewDelegate : NSObjectProtocol {
    func clickItem(url: String)
}

class BannerScrollView: UIView, UIScrollViewDelegate {

    var scrollView: UIScrollView?
    var defaultImage: UIImageView?
    var pageControl: UIPageControl?
    var timer: Timer?
    weak var delegate: BannerScrollViewDelegate?
    
    var imgs: Array<BannerModel>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatBGView(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        creatBGView(frame: frame)
    }
    
    func setImages(images: Array<BannerModel>) {
        imgs = images
        if images.count == 0 {
            return
        }
        defaultImage?.removeFromSuperview()
        
        if images.count < 3 {
            scrollView?.contentSize = CGSize(width: ScreenWidth * 3, height: BannerHeight)
        } else {
            scrollView?.contentSize = CGSize(width: ScreenWidth * CGFloat(images.count), height: BannerHeight)
        }
        pageControl?.numberOfPages = images.count

        for index in 0...2 {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(index) * ScreenWidth, y: 0, width: ScreenWidth, height: BannerHeight))
            imageView.contentMode = UIViewContentMode.scaleToFill
            scrollView?.addSubview(imageView)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
            imageView.addGestureRecognizer(tap)
        }
        startTimer()
        updateImage()
    }
    
    func creatBGView(frame: CGRect) {
        setScrollView()
        setPageControl()
        defaultImage = UIImageView.init(frame: frame)
        defaultImage?.contentMode = UIViewContentMode.scaleAspectFill
        defaultImage?.image = UIImage.init(named: "bannerImg")
        self.addSubview(defaultImage!)
    }
    
    //创建ScrollView
    func setScrollView() {
        if scrollView == nil {
            scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: BannerHeight))
            scrollView?.showsVerticalScrollIndicator = false
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.delegate = self
            scrollView?.bounces = false
            scrollView?.isPagingEnabled = true
            self.addSubview(scrollView!)
        }
    }
    
    //创建PageControl
    func setPageControl() {
        if pageControl == nil {
            pageControl = UIPageControl.init()
            pageControl?.currentPage = 0
            pageControl?.pageIndicatorTintColor = UIColor.white
            pageControl?.currentPageIndicatorTintColor = UIColor.red
            pageControl?.center = CGPoint(x: ScreenWidth / 2.0, y: (scrollView?.frame.size.height)! - 15)
            self.addSubview(pageControl!)
        }
    }
    
    //更新图片
    func updateImage() {
        for index in 0...(scrollView?.subviews.count)! - 1 {//取出scrollview 上的三个子试图 imageView
            let imageView: UIImageView = scrollView?.subviews[index] as! UIImageView
            var ind = pageControl?.currentPage//拿到当前显示的页数
            if index == 0 {//如果是第一张imageView，也就是最左边的那张imageView
                ind = ind! - 1//显示的图片应该是当前页数 -1
            } else if index == 2 {//如果是第三张imageView，也就是最右边的imageView
                ind = ind! + 1//显示的图片应该是当前页数 +1
            }
            if ind! < 0 {//如果inde < 0 把页数重置位最后一张
                ind = (imgs?.count)! - 1
            } else if ind! >= (imgs?.count)! {
                ind = 0//将右边的imageView的currentpage设为0
            }
            imageView.tag = ind!//设置 iamge 的tag 值
            if (imgs?.count)! > 0 {
                let string: String = (imgs?[ind!].picPath)!
                imageView.kf.setImage(with: URL.init(string: baseImageURLWithPath(urlString: string)), placeholder: UIImage.init(named: "bannerImg"))
            }
            imageView.isUserInteractionEnabled = true
        }
        scrollView?.contentOffset = CGPoint(x: ScreenWidth, y: 0)//始终让 偏移 量停留在最中间的这张
    }
    
    @objc func tapClick(tap: UITapGestureRecognizer) {
        delegate?.clickItem(url: (imgs?[(tap.view?.tag)!].url)!)
    }
    
    //动画显示第二张
    @objc func nextImage() {
        scrollView?.setContentOffset(CGPoint(x: 2 * ScreenWidth, y: 0), animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateImage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateImage()
    }
    
    //在此方法中 设置pageControl 的page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var page = 0
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        for index in 0...(scrollView.subviews.count) - 1 {
            let imageView: UIImageView = scrollView.subviews[index] as! UIImageView
            var distance: CGFloat = 0.0
            distance = abs(CGFloat(imageView.frame.origin.x) - CGFloat(scrollView.contentOffset.x))
            if distance < minDistance {
                minDistance = distance
                page = imageView.tag
            }
        }
        pageControl?.currentPage = page
    }
    
    //开启定时器
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    //结束定时器
    func stopTimer() {
        if (timer?.isValid != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

}

//
//  SubTitleView.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/15.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import SnapKit

let kSystemOriginColor = UIColor(red: 0.96, green: 0.39, blue: 0.26, alpha: 1.0)
let kSystemBlackColor = UIColor(red: 0.38, green: 0.39, blue: 0.40, alpha: 1.0)


protocol SubTitleViewDelegate: NSObjectProtocol {
    // 当前选中第index个标题的代理毁掉
    func findSubTitleViewDidSelected(_ titleView: SubTitleView, atIndex: NSInteger, title: String)
}


class SubTitleView: UIView {
    
    // MARK:- 代理
    weak var delegate: SubTitleViewDelegate?
    
    // MARK:- 自定义属性
    var subTitleBtnArray: [UIButton] = [UIButton]()
    var currentSelectedBtn: UIButton!
    
    var titleArray: [String] = [] {
        didSet{
            // 配置子标题
            configSubTitles()
        }
    }
    
    // MARK:- 懒加载属性
    /// 下方的滑块指示器
    lazy var sliderView: UIView  = { [unowned self] in
        let view = UIView()
        view.backgroundColor = kSystemOriginColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 30, height: 2))
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left).offset(5)
        })
        return view
        }()
    
    // MARK:- 生命周期
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.white
    }
}

// MARK:- 跳转
extension SubTitleView {
    func jump2Show(at index: NSInteger) {
        if index < 0 || index >= subTitleBtnArray.count {
            return
        }
        let btn = subTitleBtnArray[index]
        selectedAtBtn(btn, isFirstStart: false)
    }
}

// MARK:- 配置子标题
extension SubTitleView {
    fileprivate func configSubTitles() {
        // 每一个titleBtn的宽度
        let btnW = ScreenWidth / CGFloat(titleArray.count)
        
        for index in 0..<titleArray.count {
            let title = titleArray[index]
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(kSystemBlackColor, for: .normal)
            btn.setTitleColor(kSystemOriginColor, for:.selected)
            btn.setTitleColor(kSystemOriginColor, for: [.highlighted, .selected])
            btn.frame = CGRect(x: CGFloat(index) * btnW, y: 0, width: btnW , height: 38)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.adjustsImageWhenDisabled = false
            btn.addTarget(self, action: #selector(subTitleClick(_ :)), for: .touchUpInside)
            subTitleBtnArray.append(btn)
            addSubview(btn)
        }
        
        guard let firstBtn = subTitleBtnArray.first else {return}
        selectedAtBtn(firstBtn, isFirstStart: true)
    }
    
    /// 当前选中了某一个按钮
    fileprivate func selectedAtBtn(_ btn: UIButton, isFirstStart: Bool) {
        btn.isSelected = true
        currentSelectedBtn = btn
        sliderView.snp.updateConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(btn.x + btn.width * 0.5 - 15)
        }
        if !isFirstStart {
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.layoutIfNeeded()
            })
        }
        unSelectedAllBtn(btn)
    }
    
    /// 对所有非选中的按钮执行反选操作
    fileprivate func unSelectedAllBtn(_ btn: UIButton) {
        for sbtn in subTitleBtnArray {
            if sbtn == btn {
                continue
            }
            sbtn.isSelected = false
        }
    }
}

// MARK:- 事件监听
extension SubTitleView {
    @objc func subTitleClick(_ btn: UIButton) {
        if btn == currentSelectedBtn {
            return
        }
        //实际上 ? 代替了responsed
        delegate?.findSubTitleViewDidSelected(self, atIndex: subTitleBtnArray.index(of: btn)!, title: btn.titleLabel?.text ?? "")
        
        selectedAtBtn(btn, isFirstStart: false)
    }
}


//
//  HomePageNiceTableViewCell.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/22.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import Kingfisher

//@objc protocol HomePageNiceDelegate:NSObjectProtocol {
//    @objc optional
//    func homeDidSelectItemIndex(index:NSInteger)
//}
protocol HomePageNiceDelegate : NSObjectProtocol {
    func homeDidSelectItemIndex(index:NSInteger)
}

class HomePageNiceTableViewCell: UITableViewCell {
    
    weak var delegate : HomePageNiceDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataWithArray(array : Array<NiceViewModel>) {
    
        let width = UIScreen.main.bounds.size.width / CGFloat(array.count)
        let height = 60
        
        for (index, model) in array.enumerated() {
            print(index)
            let button : CenterButton = CenterButton.init(frame: CGRect(x: width * CGFloat(index), y: 10, width: width , height: CGFloat(height) ))
            button.tag = index
            button.setFont(font: UIFont.systemFont(ofSize: 14))
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitle(model.title, for: UIControlState.normal)
            button.setImage(UIImage(named: model.picPath), for: UIControlState.normal)
            button.addTarget(self, action: #selector(tapped), for: UIControlEvents.touchUpInside)
            self.addSubview(button)
        }
    }
    
    @objc func tapped(button : UIButton) {
        delegate?.homeDidSelectItemIndex(index: button.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class NiceViewModel : NSObject {
    
    var picPath : String = ""
    var title : String = ""
    var url : String = ""
    
}

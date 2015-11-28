//
//  ZYNoteCell.swift
//  MyNote_swift
//
//  Created by zhuyongqing on 15/10/22.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit
import Foundation

let kImgH:CGFloat = 60        //背景高
let kLabelLeft:CGFloat = 45
let knailH:CGFloat = 60       //钉子的高度
let kTen:CGFloat = 10
let kDuration = 0.2   //动画时间
let kHeight:CGFloat = 70     //cell 的高度
let smallImgW:CGFloat = 44   //小图宽
let smallImgH:CGFloat = 30   //小图高
let ksize = UIScreen.mainScreen().bounds.size

class ZYNoteCell: UITableViewCell {
    
    //内容
    var titleLabel:UILabel!
    //时间label
    var timeLabel:UILabel!
    //背景图
    var backImg:UIImageView!
    //钉子图
    var nailImg:UIImageView!
    //间距
    var backLine:UIView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
         super.init(style:style, reuseIdentifier:reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor();
        
        //背景图
        self.backImg = UIImageView.init();
        self.backImg.image = UIImage.init(named: "list_item_bg");
        self.backImg.contentMode = UIViewContentMode.ScaleAspectFill;
        self.backImg.clipsToBounds = true;
        self.contentView.addSubview(self.backImg);
        
        //钉子图
        self.nailImg = UIImageView.init();
        self.nailImg.image = UIImage.init(named: "clip_n");
        self.nailImg.contentMode = UIViewContentMode.ScaleAspectFill;
        self.nailImg.clipsToBounds = true;
        self.contentView.addSubview(self.nailImg);
        
        //时间 kRGBcolor(196, 179, 159); kRGBcolor(114, 80, 62);
        self.timeLabel = UILabel.init();
        self.timeLabel.textColor = UIColor.init(red: 196/255.0, green: 179/255.0, blue: 159/255.0, alpha: 1);
        self.backImg.addSubview(self.timeLabel);
  
        //内容
        self.titleLabel = UILabel.init();
        self.titleLabel.textColor = UIColor.init(red: 114/255.0, green:80/255.0 , blue: 62/255.0, alpha: 1);
        self.backImg.addSubview(self.titleLabel);
        
        //上方的间距
        self.backLine = UIView.init();
        backLine.backgroundColor = UIColor.clearColor();
        self.contentView.addSubview(self.backLine);
    }
    
   internal func buildView(){
    
        //间距
        self.backLine.frame = CGRectMake(0,0,ksize.width,kTen);
        //背景
        self.backImg.frame = CGRectMake(0,self.backLine.frame.height,ksize.width,kImgH);
        //钉子
        self.nailImg.frame = CGRectMake(0,self.backLine.frame.height+3,23,knailH);
        //时间
        self.timeLabel.frame = CGRectMake(kLabelLeft,3,ksize.width-80,15);
        self.timeLabel.font = UIFont.systemFontOfSize(13);
        //内容
        self.titleLabel.frame = CGRectMake(kLabelLeft,self.timeLabel.frame.height-2,ksize.width-kLabelLeft-smallImgW,kHeight-self.timeLabel.frame.height);
        self.titleLabel.font = UIFont.systemFontOfSize(15);
    }
    
}

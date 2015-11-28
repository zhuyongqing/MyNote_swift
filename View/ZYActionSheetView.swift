//
//  ZYActionSheetView.swift
//  MyNote_swift
//
//  Created by zhuyongqing on 15/10/23.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit

let size = UIScreen.mainScreen().bounds.size
let btnW:CGFloat = 105;

public protocol ZYActionSheetViewDelegate:NSObjectProtocol{
    
    func actionSheetbuttonIndex(buttonIndex:ButtonIndex,sheet:ZYActionSheetView);
    
    func tapDo();
    
}

public class ZYActionSheetView: UIView {
    
    var dimView:UIView!     //透明
    var backView:UIView!    //背景
    var cancelBtn:ZYButton! //取消按钮
    var deleteBtn:ZYButton! //删除按钮
    var title:UILabel!      //title
    
    weak internal var delegate: ZYActionSheetViewDelegate?
    
   public func initTitle(title:String?,delegate:ZYActionSheetViewDelegate?,cancelBtntitle:String?,otherBtntitle:String?)
   {
        //透明背景
        self.dimView = UIView.init(frame: CGRectMake(0, 0, ksize.width, ksize.height));
        self.dimView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0);
        self.dimView.userInteractionEnabled = true;
        //手势
        let tap = UITapGestureRecognizer.init(target: self, action:Selector("dimViewTapDo"));
        self.dimView.addGestureRecognizer(tap);
        self.addSubview(self.dimView);
        
        //背景
        self.backView = UIView.init(frame: CGRectMake(0, ksize.height+btnW,ksize.width,btnW));
        self.backView.backgroundColor = UIColor.whiteColor();
        self.addSubview(self.backView);
        
        //取消按钮
        self.cancelBtn = ZYButton.init(type: UIButtonType.Custom);
        self.cancelBtn.frame = CGRectMake(ksize.width-65,5,60,40);
        self.cancelBtn.setBackgroundImage(UIImage.init(named: "button_bg"), forState: UIControlState.Normal);
        self.cancelBtn.setTitle("取消", forState: UIControlState.Normal);
        self.cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(13);
        self.cancelBtn.addTarget(self, action: Selector("cancelBtnDo:"), forControlEvents: UIControlEvents.TouchUpInside);
        self.cancelBtn.buttonIndex = .cancelButtonIndex;
        self.backView.addSubview(self.cancelBtn);
        
        //title
        self.title = UILabel.init();
        self.title.frame = CGRectMake(ksize.width/2-80,10, 160,30);
         self.title.text = title;
        self.title.font = UIFont.systemFontOfSize(14);
        self.title.textAlignment = NSTextAlignment.Center;
        self.backView.addSubview(self.title);
        
        //分割线
        let line = UIView.init(frame: CGRectMake(0, self.title.frame.height+15,ksize.width,1));
        line.backgroundColor = UIColor.init(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1);
        self.backView.addSubview(line);
        
        //删除按钮
        self.deleteBtn = ZYButton.init(type: UIButtonType.Custom);
        self.deleteBtn.frame = CGRectMake(30,self.backView.frame.height-45,ksize.width-60,30);
         self.deleteBtn.backgroundColor = UIColor.init(red: 173/255.0, green: 78/255.0, blue: 76/255.0, alpha: 1);
        self.deleteBtn.layer.cornerRadius = 5;
        self.deleteBtn.setTitle(otherBtntitle, forState: UIControlState.Normal);
        self.deleteBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        self.deleteBtn.titleLabel?.font = UIFont.systemFontOfSize(17);
        self.deleteBtn.buttonIndex = .deleteButtonIndex;
         self.deleteBtn.addTarget(self, action: Selector("cancelBtnDo:"), forControlEvents: UIControlEvents.TouchUpInside);
    
        self.backView.addSubview(self.deleteBtn);
    
        self.delegate = delegate;
    }
    
    //消除背景
    func dimViewTapDo(){
        
        self.delegate?.tapDo();
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.backView.frame = CGRectMake(0,ksize.height,ksize.width,btnW);
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.dimView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0);
                    }, completion: { (Bool) -> Void in
                        self.removeFromSuperview();
                })
                
        }
    }
    
    //显示
   internal func show(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.dimView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3);
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.backView.frame = CGRectMake(0, ksize.height-btnW,ksize.width,btnW)
                    }, completion: { (Bool) -> Void in
                        
                })
        }
    }
    
    //MARK:取消按钮点击
    func cancelBtnDo(btn:ZYButton){
     
         self.delegate?.actionSheetbuttonIndex(btn.buttonIndex,sheet: self);
    }
}

public enum ButtonIndex{
   case cancelButtonIndex
   case deleteButtonIndex
}

class ZYButton: UIButton {
    var buttonIndex:ButtonIndex!
}


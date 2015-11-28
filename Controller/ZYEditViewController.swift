//
//  ZYEditViewController.swift
//  MyNote_swift
//
//  Created by zhuyongqing on 15/10/22.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit
import CoreData
import Foundation

let kwinY:CGFloat = 64
let kBtnW:CGFloat = 40
let kBtnH:CGFloat = 30

enum editType{
   case kEditTypechange
   case kEditTypenew
}

class ZYEditViewController: UIViewController,UITextViewDelegate,ZYActionSheetViewDelegate {

    //是否是创建新的
    var types:editType!
    //旧的note
    var note:ZYMyNoteModel?
    //新的note
    lazy var newNote:ZYMyNoteModel = {
        //创建一个新的模型
        var note:ZYMyNoteModel = NSEntityDescription.insertNewObjectForEntityForName("ZYMyNoteModel", inManagedObjectContext:self.myDelegate.managedObjectContext) as! ZYMyNoteModel
        return note;
    }()
    //照片
    lazy var photoImgView:UIImageView = {
        let imgView = UIImageView.init();
        imgView.frame = CGRectMake(30,100,self.view.frame.width-60,200);
        imgView.contentMode = UIViewContentMode.ScaleAspectFill;
        imgView.clipsToBounds = true;
        return imgView;
    }()
    //代理
    var myDelegate:AppDelegate!
    //时间
    var timeLabel:UILabel!
    //内容
    var textView:UITextView?
    //主视图的背景
    var mainView:UIView!
    //是否删除
    var isDelete:Bool?
    //是否是编辑状态
    var isEdit:Bool!
    //右上角删除按钮
    var deleteBtn:UIButton!
    //右上角保存分享按钮
    var saveBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加背景
        self.buildBackImg();
        
        //得到appdelegate
        self.myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        //主视图
        self.buildMainView();
        
        //导航栏
        self.buildNaviBar();
        
        //初始为否
        self.isEdit = false;
    }
    
    //MARK:背景
    func buildBackImg(){
        let backImg = UIImageView.init(image:UIImage.init(named: "home_bg"));
        backImg.frame = self.view.frame;
        backImg.contentMode = UIViewContentMode.ScaleAspectFill;
        backImg.clipsToBounds = true;
        self.view .addSubview(backImg);
    }
    
    //MARK:创建主视图
    func buildMainView(){
        //主视图
        self.mainView = UIView.init()
        self.mainView.frame = CGRectMake(0,kwinY,self.view.frame.width, self.view.frame.height);
        self.view .addSubview(self.mainView);
        
        //背景
        let img = UIImageView.init(image: UIImage.init(named: "note_paper_background_full"));
        img.contentMode = UIViewContentMode.ScaleAspectFill;
        img.clipsToBounds = true;
        img.userInteractionEnabled = true;
        img.frame = CGRectMake(0, 0, self.mainView.frame.width, self.mainView.frame.height);
        self.mainView.addSubview(img);
        
        //时间显示
        self.timeLabel = UILabel.init(frame:CGRectMake(5, 0, self.view.frame.size.width-100, kBtnW))
        self.timeLabel.textColor = UIColor.init(red: 183/255.0, green: 166/255.0, blue: 143/255.0, alpha: 1);
        self.timeLabel.font = UIFont.systemFontOfSize(13)
        self.timeLabel.text = "今天 \(self.returnNowdatewith(0))";
        img.addSubview(self.timeLabel);
        
        //分割线
        let backView = UIView.init();
        backView.frame = CGRectMake(0, self.timeLabel.frame.height,self.view.frame.width,1)
        backView.backgroundColor = UIColor.init(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1);
        img.addSubview(backView);
        
        //内容
        self.textView = UITextView.init(frame: CGRectMake(0,self.timeLabel.frame.height+5, self.mainView.frame.width,self.mainView.frame.height-self.timeLabel.frame.height))
        self.textView!.font = UIFont.systemFontOfSize(15);//kRGBcolor(93,56,42)
        self.textView!.textColor = UIColor.init(red: 93/255.0, green: 56/255.0, blue: 42/255.0, alpha: 1);
        self.textView!.delegate = self;
        self.textView!.selectedRange = NSMakeRange(self.textView!.text.characters.count, 0);
        self.textView!.backgroundColor = UIColor.clearColor();
        self.textView!.scrollEnabled = true;
        img.addSubview(self.textView!);
        
        if(self.types == .kEditTypechange){
            self.textView!.text = self.note!.text;
            self.timeLabel.text = "\(self.intervalSinceNow(self.note!.trueTime!)) \(self.note!.time!)"
        }
    }
    
    //MARK:保存
    func save(){
        if (self.types == .kEditTypenew) {
            //如果是创建新的
            if !((self.textView!.text as NSString).isEqualToString("") && self.isDelete!.boolValue == false){
                self.newNote.text = self.textView!.text;
                    self.newNote.time = self.returnNowdatewith(0) as String;
                    self.newNote.trueTime = self.returnNowdatewith(1) as String;
                    self.myDelegate.saveContext();
            }else{
                self.myDelegate.managedObjectContext.deleteObject(self.newNote as NSManagedObject);
            }
        }else{
            if var str = self.note?.text{
                if (!((self.textView?.text)! as NSString).isEqualToString((self.note?.text)!) && self.isDelete?.boolValue == false){
                    str = (self.textView?.text)!;
                    self.note?.time = self.returnNowdatewith(0) as String;
                    self.note?.trueTime = self.returnNowdatewith(1) as String;
                    self.myDelegate.saveContext();
                }
            }
        }
    }
    
    //MARK:导航栏
    func buildNaviBar(){
        //左侧按钮
        let btn = UIButton.init(type: UIButtonType.Custom);
        btn.frame = CGRectMake(0, 0, 50, 40);
        btn.setBackgroundImage(UIImage.init(named: "btn_long_bg_n"), forState: UIControlState.Normal);
        btn.setTitle("列表", forState: UIControlState.Normal);
        btn.addTarget(self, action: Selector("back"), forControlEvents: UIControlEvents.TouchUpInside);
        btn.titleLabel?.font = UIFont.systemFontOfSize(12);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        let item = UIBarButtonItem.init(customView: btn);
        self.navigationItem.leftBarButtonItem = item;
        
        //右侧按钮
        //加入图片或删除
        self.deleteBtn = UIButton.init(type: UIButtonType.Custom);
        
        self.deleteBtn.addTarget(self, action: Selector("addPhotoandDelete"), forControlEvents: UIControlEvents.TouchUpInside);
        
        //保存或者分享
        saveBtn = UIButton.init(type: UIButtonType.Custom);
        saveBtn.setBackgroundImage(UIImage.init(named: "button_bg"), forState: UIControlState.Normal);
    
        saveBtn.frame = CGRectMake(0, 0, 40, 43);
        saveBtn.addTarget(self, action: Selector("saveBtnorshare"), forControlEvents: UIControlEvents.TouchUpInside);
        //设置图片
        self.setBtnimg(0);
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: saveBtn),UIBarButtonItem.init(customView: deleteBtn)];
     }
    
    //MARK:保存或分享
    func saveBtnorshare(){
        if (self.isEdit.boolValue == true) {
            self.isEdit = false;
            self.textView!.resignFirstResponder();
            //保存
            self.save();
            //设置图片
            self.setBtnimg(0);
        }
    }
    
    //MARK:删除或加图片
    func addPhotoandDelete(){
        if(self.isEdit.boolValue == false){
            
            
            let sheet = ZYActionSheetView();
            sheet.initTitle("确定要删除此条便签吗", delegate: self, cancelBtntitle:"取消", otherBtntitle: "删除");
            sheet.frame = CGRectMake(0, 0, self.view.frame.width,self.view.frame.height);
            self.view.addSubview(sheet);
            sheet.show();
            self.deleteBtn.enabled = false;
        }
    }
    
    //MARK: actionSheet代理 case cancelButtonIndex
   // case deleteButtonIndex
    func actionSheetbuttonIndex(buttonIndex: ButtonIndex, sheet: ZYActionSheetView) {
        sheet.dimViewTapDo();
        self.deleteBtn.enabled = true;
        if buttonIndex == .cancelButtonIndex{
           
        }else{
            //删除
            self.isDelete = true;
            if self.types == .kEditTypechange{
                self.myDelegate.managedObjectContext.deleteObject(self.note! as NSManagedObject);
            }else{
                self.myDelegate.managedObjectContext.deleteObject(self.newNote as NSManagedObject);
            }
            //保存
            self.myDelegate.saveContext()
            //动画
            self.deleteAnmition();
        }
    }
    
    func tapDo(){
        self.deleteBtn.enabled = true;
    }
    
    //MARK:删除的动画
    func deleteAnmition(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.deleteBtn.setImage(UIImage.init(named: "iOSbtn_0030"), forState: UIControlState.Normal);
                self.mainView.transform = CGAffineTransformMakeScale(0.06, 0.06);
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mainView.frame.origin = CGPointMake(self.view.frame.width-90, 20)
                    
                    }, completion: { (Bool) -> Void in
                        self.navigationController?.popViewControllerAnimated(true);
                })
        }
    }
    
    //MARK:返回的按钮
    func back(){
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    //MARK:textView代理
    func textViewDidBeginEditing(textView: UITextView) {
        self.isEdit = true;
        self.setBtnimg(1);
    }
    
    //MARK:改变导航栏按钮的图片
    func setBtnimg(type:Int){
        if type == 1{
            self.deleteBtn.setBackgroundImage(UIImage.init(named: "button_bg"),
                forState: UIControlState.Normal);
            self.deleteBtn.setImage(UIImage.init(named: "btn_camera"), forState: UIControlState.Normal);
            self.deleteBtn.frame.size = CGSizeMake(40-3, 40+3);
            self.saveBtn.setImage(UIImage.init(named: "btn_done"), forState: UIControlState.Normal);
        }else
        {
            //非编辑状态
            self.deleteBtn.setBackgroundImage(UIImage.init(named: "iOSbtnBg"), forState: UIControlState.Normal);
            self.deleteBtn.setImage(UIImage.init(named: "iOSbtn_0001"), forState: UIControlState.Normal);
            self.deleteBtn.frame.size = CGSizeMake(40, 30);
            
            self.saveBtn.setImage(UIImage.init(named: "btn_send"), forState: UIControlState.Normal);
        }
    }
    
    //MARK:计算时间距离现在  
    func intervalSinceNow(theDate:NSString)->(NSString){
        
        let date = NSDateFormatter.init();
        date.dateFormat = "yyyy-MM-dd HH:mm:ss";
        
        let d = date.dateFromString(theDate as String);
        
        let late = (d?.timeIntervalSince1970)!*1;
        
        let dat = NSDate.init();
        
        let now = dat.timeIntervalSince1970*1;
        
        var timeString = NSString();
        
        let cha = now-late;
        
        //如果是昨天
        let senddate = NSDate.init();
        
        let dateformatter = NSDateFormatter.init();
        
        dateformatter.locale = NSLocale.init(localeIdentifier: "zh-CN");
        
        dateformatter.dateFormat = "dd";
        
        let locationString:NSString = dateformatter.stringFromDate(senddate);
        
        let old:NSString = dateformatter.stringFromDate(d!);
        
        if (cha/86400>2)
        {
            timeString = "\(cha/86400)"
            timeString = timeString.substringToIndex(timeString.length-7);
            
            timeString = "\(timeString)天前";
            
        }else if(locationString.intValue > old.intValue){
            timeString = "昨天";
        }else
        {
            timeString = "今天";
        }
        
        return timeString;
    }
    
    //MARK:获取当前时间
    func returnNowdatewith(type: NSInteger)->(NSString){
        //获取当前时间
        let senddate = NSDate.init();
        
        let dateformatter = NSDateFormatter.init()
        dateformatter.locale = NSLocale.init(localeIdentifier: "zh-CN")
        if (type==0) {
            dateformatter.dateFormat = "HH:mm YYYY年MM月dd日";
        } else{
            dateformatter.dateFormat = "YYYY.MM.dd HH:mm:ss";
        }
        
        let locationString = dateformatter.stringFromDate(senddate);
        
        return locationString;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
        self.save();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.isDelete = false;
    }

}

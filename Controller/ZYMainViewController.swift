//
//  ZYMainViewController.swift
//  MyNote_swift
//
//  Created by zhuyongqing on 15/10/21.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit
import CoreData

let TIME = "time"
let IMGE = "imge"
let TRUETIME = "trueTime"
let TEXT = "text"

class ZYMainViewController: UITableViewController {
    //获取管理
    var context:NSManagedObjectContext!
    var fetch:NSFetchRequest!
    var myDelegate:AppDelegate!
    //懒加载数组
    lazy var allNote:NSMutableArray = {
        var temp = NSMutableArray();
        return temp;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MyNote";
        //设置背景
        self.setBackground();
        //设置导航栏
        self.buildNavibar();
        
        //tableview 注册cell
        self.tableView.registerClass(ZYNoteCell.self, forCellReuseIdentifier:"NOTE")
        
        // 实例化NSManagedObjectContext对象
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
        // 实例化NSFetchRequest对象
        self.fetch = NSFetchRequest(entityName: "ZYMyNoteModel");
        self.myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
       // self.insert();
      
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        //查询所有
        self.findallNoteModel();
    }
    
    //MARK:设置背景
    func setBackground(){
        let img = UIImageView.init(frame: UIScreen.mainScreen().bounds);
        img.image = UIImage.init(named: "home_bg");
        self.tableView.backgroundView = img;
        
        //设置无分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    //MARK:获得当前数据库中所有数据
    func findallNoteModel(){
       //创建一个查询
        do{
            //获取数组
            let data:NSArray =  try self.context.executeFetchRequest(self.fetch);
            let sort = NSSortDescriptor.init(key:TRUETIME, ascending: false);
            let all:NSArray = data.sortedArrayUsingDescriptors([sort]);
            self.allNote = all.mutableCopy() as! NSMutableArray;
            self.tableView.reloadData();
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    //MARK:导航栏
    func buildNavibar(){
        //创建导航栏右边的按钮
        let btn = UIButton.init(type: UIButtonType.Custom);
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.setBackgroundImage(UIImage.init(named: "button_bg"), forState: UIControlState.Normal);
        btn.setImage(UIImage.init(named: "btn_new"), forState: UIControlState.Normal);
        btn.addTarget(self, action:Selector("rightBarAction"), forControlEvents:UIControlEvents.TouchUpInside);
        let rightBar = UIBarButtonItem.init(customView: btn);
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    
    //MARK:导航栏创建新的note按钮
    func rightBarAction(){
        let edit = ZYEditViewController();
        edit.types = .kEditTypenew;
        self.navigationController?.pushViewController(edit, animated: true);
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allNote.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let ID = "NOTE";
        var cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath) as! ZYNoteCell;
        if cell.isEqual(nil){
            cell = ZYNoteCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: ID);
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //创建cell
        cell.buildView();
        let note:ZYMyNoteModel = self.allNote[indexPath.row] as! ZYMyNoteModel;
        cell.timeLabel.text = "\(self.intervalSinceNow(note.trueTime!)) \(note.time!)"
        cell.titleLabel.text = "\(note.text!)"

        return cell;
    }
    //MARK:选择cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let edit = ZYEditViewController();
        //设定类型为 改 查
        edit.types = .kEditTypechange;
        edit.note = self.allNote[indexPath.row] as? ZYMyNoteModel;
        self.navigationController?.pushViewController(edit, animated: true);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    //MARK:删除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            //从数据库中删除
           self.context.deleteObject((self.allNote[indexPath.row] as! NSManagedObject))
            //数组中
            self.allNote.removeObjectAtIndex(indexPath.row);
            //tableview 删除
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top);
            //保存
            self.myDelegate.saveContext();
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

}

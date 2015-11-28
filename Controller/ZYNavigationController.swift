//
//  ZYNavigationController.swift
//  MyNote_swift
//
//  Created by zhuyongqing on 15/10/21.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit

class ZYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏背景
        self.navigationBar.barTintColor = UIColor.init(patternImage: UIImage.init(named: "nav_bg")!);
        
        //设置导航栏字体颜色
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont.systemFontOfSize(17)];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

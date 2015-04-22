//
//  CustomTabBarController.swift
//  RemindWhere
//
//  Created by Adriano Soares on 21/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var tintColor = (UIApplication.sharedApplication().delegate as! AppDelegate).tintColor
        
        var tabBar = self.tabBar
        for index in 0..<tabBar.items!.count {
            var item = tabBar.items![index] as! UITabBarItem
            item.image = item.selectedImage.imageWithColor(tintColor).imageWithRenderingMode(.AlwaysOriginal)
            item.setTitleTextAttributes([tintColor: NSForegroundColorAttributeName],
                forState: UIControlState.Normal)
        }
        
    }
}

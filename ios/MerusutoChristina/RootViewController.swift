//
//  RootViewController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu {

	override func awakeFromNib() {
//		self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"contentController"];
//		self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"menuController"];
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contentController")
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("menuController")
        
        self.backgroundImage = UIImage(named: "Stars")
	}
}

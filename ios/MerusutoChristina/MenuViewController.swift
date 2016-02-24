//
//  MenuViewController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.4, UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        self.view.addSubview(self.tableView!)
        self.tableView?.backgroundColor = UIColor.greenColor()
    }
}

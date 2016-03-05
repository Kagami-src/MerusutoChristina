//
//  MenuViewController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

//菜单栏
public enum MenuList : Int {
	case Character // 人物图鉴
	case Monster // 魔宠图鉴
	case Simulator // 模拟抽卡
	case Download // 下载
	case Help // 帮助
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK:属性列表
	var tableView: UITableView?

	// 菜单栏
	let title1 = (icon : "icon_character.png", name: "人物图鉴", menuType: MenuList.Character)
	let title2 = (icon: "icon_monster.png", name: "魔宠图鉴", menuType: MenuList.Monster)

	let title3 = (icon: "icon_simulator.png", name: "模拟抽卡", menuType: MenuList.Simulator)
	let title4 = (icon: "icon_download.png", name: "下载资源包", menuType: MenuList.Download)
	let title5 = (icon: "icon_help.png", name: "帮助", menuType: MenuList.Help)

	typealias TitleType = (icon: String, name: String, menuType: MenuList)
	typealias ArrayType = Array < TitleType >
	var titles: Array < ArrayType >?

	// MARK:方法
	override func viewDidLoad()
	{
		super.viewDidLoad()

		self.tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.6, UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
		self.tableView?.center = CGPointMake(tableView!.center.x, UIScreen.mainScreen().bounds.height / 2 + 20)

		// self.titles = [[title1, title2], [title3, title4, title5]]
		self.titles = [[title1], [title4, title5]]

		self.tableView?.delegate = self
		self.tableView?.dataSource = self

		self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "test")
		self.tableView?.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
		self.tableView?.tableFooterView = UIView(frame: CGRectZero)
		self.tableView?.scrollEnabled = false

		self.view.addSubview(self.tableView!)
	}

	// MARK:UITableViewDelegate
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.titles!.count
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.titles![section].count
	}

	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 0 : 20
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)

		let title = self.titles![indexPath.section][indexPath.row].name
		cell?.textLabel?.text = title

		let iconName = self.titles![indexPath.section][indexPath.row].icon
		cell?.imageView?.image = UIImage(named: iconName)

		return cell!
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		cell?.selected = false

		let clickMenu = self.titles![indexPath.section][indexPath.row].menuType

		let mainController = self.sideMenuViewController as! RootViewController

		switch (clickMenu) {
			case MenuList.Character:
				mainController.switchToController(0)

			case MenuList.Monster:
				mainController.switchToController(1)

			case MenuList.Simulator:
				mainController.switchToController(2)

			case MenuList.Download:
				mainController.downloadAllResource()

			case MenuList.Help:
				UIApplication.sharedApplication().openURL(NSURL(string: "http://merusuto.gq/jump/about.html")!)

			default:
				break
		}
	}
}

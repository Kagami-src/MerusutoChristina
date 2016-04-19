//
//  MonsterListController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SDWebImage
import RESideMenu
import SnapKit

class MonsterListController: CharacterListController {

	override func viewDidLoad() {

		pickers = [rarePicker, monster_rarePicker, elementPicker, monster_skinPicker, monster_skillPicker, aareaPicker, serverPicker]

		cellIdentifier = "monster cell"

		classRootPicker = monster_rootPicker

		super.viewDidLoad()
	}

	override func initTableView() {

		super.initTableView()

		self.tableView.registerClass(MonsterListCell.classForCoder(), forCellReuseIdentifier: "monster cell")
	}

	override func loadData() {

		postShowLoading()

		DataManager.loadJSONWithSuccess("monsters", success: { (data) -> Void in
			for (_, each) in data {

				let item = MonsterItem(data: each)
				self.allItems.append(item)
			}

			self.displayedItems = self.sort(self.allItems)

			dispatch_sync(dispatch_get_main_queue(), {
				self.tableView.reloadData()
				postHideLoading()
			})
		})
	}

	override func initNavigationBarButtonItem() {

		super.initNavigationBarButtonItem()

		self.btnSort.tag = 0;
		self.btnFilter.tag = 1;

		self.navigationItem.rightBarButtonItems = [self.btnFilter, self.btnSort]
	}

	override func updateLevelMode(items: [CharacterItem]) {
		// 空实现，不执行等级计算
	}

	// MARK:UITableView Delegate
	override func tableView(tableView : UITableView, cellForRowAtIndexPath indexPath : NSIndexPath) -> UITableViewCell
	{
		let cell: MonsterListCell = tableView.dequeueReusableCellWithIdentifier("monster cell") as! MonsterListCell

		cell.item = self.displayedItems![indexPath.row] as! MonsterItem;

		return cell;
	}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("Show Monster Detail Segue", sender: displayedItems![indexPath.row])
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Show Monster Detail Segue") {
            
            let controller: MonsterDetailController = segue.destinationViewController as! MonsterDetailController
            
            print(sender)
            controller.item = sender as! MonsterItem
        }
    }

	override func filter(items: [CharacterItem]) -> [CharacterItem] {

		return items.filter({ (item: CharacterItem) -> Bool in

			let temp: MonsterItem = item as! MonsterItem

			if (monster_rarePicker.check(temp.rare) || elementPicker.check(temp.element) || monster_skinPicker.check(temp.skin) || monster_skillPicker.checkString(temp.skill) || aareaPicker.check(temp.aarea) || serverPicker.check(temp.server))
			{
				return false
			}
			return true
		})
	}

	override func sort(var items: [CharacterItem]) -> [CharacterItem] {

		items.sortInPlace { (lhs: CharacterItem, rhs: CharacterItem) -> Bool in

			let lhsTemp: MonsterItem = lhs as! MonsterItem
			let rhsTemp: MonsterItem = rhs as! MonsterItem

			switch monster_sortPicker.value
			{
			case 0:
				return lhsTemp.rare > rhsTemp.rare
			case 1:
				return lhsTemp.sklmax > rhsTemp.sklmax
			case 2:
				return lhsTemp.aarea > rhsTemp.aarea
			case 3:
				return lhsTemp.anum > rhsTemp.anum
			case 4:
				return lhsTemp.aspd > rhsTemp.aspd
			case 5:
				return lhsTemp.tenacity < rhsTemp.tenacity;
			case 6:
				return lhsTemp.mspd > rhsTemp.mspd
			case 7:
				return lhsTemp.hits > rhsTemp.hits
			default:
				return true
			}
		}

		return items
	}
}

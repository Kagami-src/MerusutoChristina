//
//  ViewController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/24.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//
import UIKit
import ActionSheetPicker_3_0
import SDWebImage
import RESideMenu

class CharacterListController: UIViewController, ActionSheetCustomPickerDelegate, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

	var allItems = [CharacterItem]()
	var displayedItems: [CharacterItem]?

	var tableView: UITableView!

	var actionSheetPicker: ActionSheetCustomPicker!
	var actionSheetPickerShown: Bool = false

	var scrollToTopButtonHidden = true

	var path: [PickerItem] = []
	var pickers = [levelPicker, sortPicker, rarePicker, elementPicker, weaponPicker, typePicker]
	var classRootPicker = rootPicker

	var pickerView: UIPickerView!

	var btnScrollToTop: UIButton!

	// MARK:UIBarButtons
	var btnMenu: UIBarButtonItem!
	var btnFilter: UIBarButtonItem!
	var btnSort: UIBarButtonItem!
	var btnCancel: UIBarButtonItem!
	var btnDone: UIBarButtonItem!
	var btnLevel: UIBarButtonItem!

	var cellIdentifier: String = "Character Cell"


	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = UIColor.clearColor();
        
		initTableView()
		initNavigationBar()
		initNavigationBarButtonItem()
		initOtherButton()

		loadData()
	}

	func initTableView() {
		self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Plain)
		self.tableView.registerClass(CharacterListCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
		self.view.addSubview(self.tableView)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.rowHeight = 111;

		self.tableView.backgroundColor = UIColor.clearColor()
		self.tableView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.view.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.top.equalTo(self.view.snp_top).offset(0)
		}
	}

	func initOtherButton() {
		self.btnScrollToTop = UIButton(type: UIButtonType.System)
		self.btnScrollToTop.alpha = 0
		self.btnScrollToTop.setTitle("回到顶部", forState: UIControlState.Normal)
		self.btnScrollToTop.addTarget(self, action: Selector("btnScrollToTop_clickHandler:"), forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(self.btnScrollToTop)
		self.btnScrollToTop.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.view.snp_bottom).offset(-8)
			make.right.equalTo(self.view.snp_right).offset(-12)
			make.width.equalTo(80)
			make.height.equalTo(30)
		}
	}

	func initNavigationBar() {
		self.automaticallyAdjustsScrollViewInsets = false;
		self.navigationController?.navigationBar.translucent = false;
		self.navigationItem.title = ""
	}

	func initNavigationBarButtonItem() {
		self.btnLevel = UIBarButtonItem(title: "等级", style: UIBarButtonItemStyle.Plain, target: self, action: "barButton_clickHandler:")
		self.btnFilter = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.Plain, target: self, action: "barButton_clickHandler:")
		self.btnSort = UIBarButtonItem(title: "排序", style: UIBarButtonItemStyle.Plain, target: self, action: "barButton_clickHandler:")
		self.btnCancel = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "btnCancel_handler:")
		self.btnDone = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "btnDone_handler:")

		self.btnSort.tag = 1;
		self.btnLevel.tag = 0;
		self.btnFilter.tag = 2;

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drawer"), style: UIBarButtonItemStyle.Done, target: self, action: "menu_handler:")
		self.navigationItem.rightBarButtonItems = [self.btnFilter, self.btnSort, self.btnLevel]
	}

	func loadData() {

		postShowLoading()

		DataManager.loadJSONWithSuccess("units", success: { (data) -> Void in
			for (_, each) in data {
				let item = CharacterItem(data: each)
				self.allItems.append(item)
			}
			self.displayedItems = self.sort(self.allItems)

			dispatch_async(dispatch_get_main_queue(), { () -> Void in

				self.tableView.reloadData()
				postHideLoading()
			})
		})
	}

	func menu_handler(sender: AnyObject) {
		self.sideMenuViewController.presentLeftMenuViewController()
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.displayedItems?.count ?? 0
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CharacterListCell

		cell.item = displayedItems![indexPath.row] as CharacterItem

		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
		self.performSegueWithIdentifier("Show Detail Segue", sender: displayedItems![indexPath.row])
        
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "Show Detail Segue") {
            
			let controller: CharacterDetailController = segue.destinationViewController as! CharacterDetailController

			controller.item = sender as! CharacterItem
		}
	}

	func showScrollToTopButton() {
		if scrollToTopButtonHidden {
			scrollToTopButtonHidden = false
			UIView.animateWithDuration(0.25, animations: {
				self.btnScrollToTop.alpha = 0.5
			})
		}
	}

	func hideScrollToTopButton() {
		if !scrollToTopButtonHidden {
			scrollToTopButtonHidden = true
			UIView.animateWithDuration(0.25, animations: {
				self.btnScrollToTop.alpha = 0
			})
		}
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y > tableView.rowHeight * 10 {
			showScrollToTopButton()
		} else {
			hideScrollToTopButton()
		}
	}

	func barButton_clickHandler(sender: UIBarButtonItem) {
		for picker in pickers {
			picker.originalValue = picker.value
		}

		if actionSheetPickerShown {
			return
		}
		actionSheetPicker = ActionSheetCustomPicker(title: "", delegate: self, showCancelButton: true, origin: sender)
		actionSheetPicker.hidePickerWithCancelAction()
		actionSheetPicker.delegate = self
		actionSheetPicker.setDoneButton(btnDone)
		actionSheetPicker.setCancelButton(btnCancel)
		actionSheetPicker.addCustomButtonWithTitle("重置", actionBlock: {
			self.btnReset_clickHandler(nil)
			self.actionSheetPickerShown = false
		})
		resetPath(classRootPicker.child(sender.tag))
		actionSheetPicker.showActionSheetPicker()
		actionSheetPickerShown = true
		reloadComponents()
	}

	func actionSheetPickerDidSucceed(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
		btnDone_handle(nil)
		actionSheetPickerShown = false
	}

	func actionSheetPickerDidCancel(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
		btnCancel_handler(nil)
		actionSheetPickerShown = false
	}

	func btnScrollToTop_clickHandler(sender: AnyObject?) {
		self.tableView.setContentOffset(CGPointZero, animated: true)
	}

	func reloadComponents() {
		pickerView.reloadAllComponents()
		for component in 0 ..< numberOfComponents {
			let filter = self.picker(byComponent: component)
			pickerView.selectRow(filter.value, inComponent: component, animated: false)
		}
	}

	func sort(var items: [CharacterItem]) -> [CharacterItem] {

		items.sortInPlace { (lhs: CharacterItem, rhs: CharacterItem) -> Bool in
			switch sortPicker.value
			{
			case 0:
				return lhs.rare > rhs.rare
			case 1:
				return lhs.dps > rhs.dps
			case 2:
				return lhs.mdps > rhs.mdps
			case 3:
				return lhs.life > rhs.life
			case 4:
				return lhs.atk > rhs.atk
			case 5:
				return lhs.aarea > rhs.aarea
			case 6:
				return lhs.anum > rhs.anum
			case 7:
				return lhs.aspd < rhs.aspd;
			case 8:
				return lhs.tenacity > rhs.tenacity
			case 9:
				return lhs.mspd > rhs.mspd
			case 10:
				return lhs.id > rhs.id
			case 11:
				return lhs.hits > rhs.hits
			default:
				return true
			}
		}

		return items
	}

	func filter(items: [CharacterItem]) -> [CharacterItem] {

		return items.filter({ (item: CharacterItem) -> Bool in
			if rarePicker.check(item.rare) ||
			elementPicker.check(item.element) ||
			weaponPicker.check(item.weapon) ||
			typePicker.check(item.type) ||
			aareaPicker.check(item.aarea) ||
			anumPicker.check(item.anum) ||
			genderPicker.check(item.gender) ||
			serverPicker.check(item.server) ||
			exchangePicker.check(item.exchange) ||
			countryPicker.checkString(item.country)
			{
				return false
			}
			return true
		})
	}

	func updateLevelMode(items: [CharacterItem]) {
		if levelPicker.value != levelPicker.originalValue {
			for item in items {
				item.levelMode = levelPicker.value
			}
		}
	}

	func resetPath(item: PickerItem) {
		path.removeAll(keepCapacity: true)
		path.append(item)
	}

	var numberOfComponents: Int {
		get {
			return picker(byComponent: 0).depth
		}
	}

	func picker(byComponent component: Int) -> PickerItem {
		if component < path.count {
			return path[component]
		} else if component == path.count {
			let last = path.last!
			let item = last.child(last.value)
			path.append(item)
			return item
		} else {
			return unknownPicker
		}
	}

	func btnCancel_handler(sender: AnyObject?) {
		for picker in pickers {
			picker.value = picker.originalValue
		}
	}

	func btnReset_clickHandler(sender: AnyObject?) {
		picker(byComponent: 0).reset()
		btnDone_handle(nil)
	}

	func btnDone_handle(sender: AnyObject?) {
		var items = allItems
		updateLevelMode(items)
		items = filter(items)
		items = sort(items)

		displayedItems = items
		tableView.reloadData()
	}

	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return numberOfComponents
	}

	func actionSheetPicker(actionSheetPicker: AbstractActionSheetPicker!, configurePickerView pickerView: UIPickerView!) {
		self.pickerView = pickerView
	}

	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return picker(byComponent: component).children.count
	}

	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return picker(byComponent: component).child(row).title
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let filter = picker(byComponent: component)
		filter.value = row

		while path.count > component + 1 {
			path.removeLast()
		}
		path.append(filter.child(row))
		reloadComponents()
	}
}

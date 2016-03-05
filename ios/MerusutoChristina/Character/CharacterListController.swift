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

class CharacterListController: UIViewController, ActionSheetCustomPickerDelegate, RESideMenuDelegate {

	@IBOutlet var loadingView: UIView!

	var allItems = [CharacterItem]()
	var displayedItems: [CharacterItem]?

	@IBOutlet var tableView: UITableView!
	@IBOutlet var scrollToTopButton: UIButton!
	@IBOutlet var actionSheetToolbar: UIToolbar!

	var actionSheetPicker: ActionSheetCustomPicker!
	var actionSheetPickerShown: Bool = false

	var scrollToTopButtonHidden = true

	@IBOutlet var rightBarButtonItemsCollection: [UIBarButtonItem]! {
		didSet {
			rightBarButtonItemsCollection.sortInPlace {
				(lhs: UIBarButtonItem, rhs: UIBarButtonItem) -> Bool in
				return lhs.tag > rhs.tag
			}
			navigationItem.rightBarButtonItems = rightBarButtonItemsCollection
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		DataManager.loadJSONWithSuccess("units", success: { (data) -> Void in
			for (_, each) in data {
				let item = CharacterItem(data: each)
				self.allItems.append(item)
			}
			self.displayedItems = self.sort(self.allItems)
			dispatch_sync(dispatch_get_main_queue(), {
				UIView.animateWithDuration(0.25, animations: {
					self.loadingView.alpha = 0
					}, completion: { finished in
					self.loadingView.hidden = true
				})
				self.tableView.reloadData()
			})
		})

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drawer"), style: UIBarButtonItemStyle.Done, target: self, action: "menu_handler:")
	}

	func menu_handler(sender: AnyObject) {
		self.sideMenuViewController.presentLeftMenuViewController()
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.displayedItems?.count ?? 0
	}

	var workaroundCell = UITableViewCell()
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let indexPaths = tableView.indexPathsForVisibleRows!
		if indexPaths.first!.row - 5 > indexPath.row || indexPaths.last!.row + 5 < indexPath.row {
			return workaroundCell
		}

		let item = displayedItems![indexPath.row] as CharacterItem
		let cell = tableView.dequeueReusableCellWithIdentifier("Unit Item Cell", forIndexPath: indexPath) as! CharacterListCell
		cell.item = item

		return cell
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "Show Detail Segue") {
			let controller: CharacterDetailController = segue.destinationViewController as! CharacterDetailController
			let indexPath = tableView.indexPathForSelectedRow!
			controller.item = displayedItems![indexPath.row] as CharacterItem
		}
	}

	func showScrollToTopButton() {
		if scrollToTopButtonHidden {
			scrollToTopButtonHidden = false
			UIView.animateWithDuration(0.25, animations: {
				self.scrollToTopButton.alpha = 0.5
			})
		}
	}

	func hideScrollToTopButton() {
		if !scrollToTopButtonHidden {
			scrollToTopButtonHidden = true
			UIView.animateWithDuration(0.25, animations: {
				self.scrollToTopButton.alpha = 0
			})
		}
	}

	func scrollViewDidScroll(scrollView: UIScrollView!) {
		if scrollView.contentOffset.y > tableView.rowHeight * 10 {
			showScrollToTopButton()
		} else {
			hideScrollToTopButton()
		}
	}

	@IBAction func sidemenuBarButtonItemTapped() {
	}

	@IBOutlet var doneButton: UIBarButtonItem!
	@IBOutlet var cancelButton: UIBarButtonItem!

	@IBAction func barButtonItemTapped(sender: UIBarButtonItem) {
		for picker in pickers {
			picker.originalValue = picker.value
		}

		if actionSheetPickerShown {
			return
		}
		actionSheetPicker = ActionSheetCustomPicker(title: "", delegate: self, showCancelButton: true, origin: sender)
		actionSheetPicker.hidePickerWithCancelAction()
		actionSheetPicker.delegate = self
		actionSheetPicker.setDoneButton(doneButton)
		actionSheetPicker.setCancelButton(cancelButton)
		actionSheetPicker.addCustomButtonWithTitle("重置", actionBlock: {
			self.resetBarButtonItemTapped()
            self.actionSheetPickerShown = false
		})
		resetPath(rootPicker.child(sender.tag))
		actionSheetPicker.showActionSheetPicker()
		actionSheetPickerShown = true
		reloadComponents()
	}

	func actionSheetPickerDidSucceed(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
		confirmBarButtonItemTapped()
		actionSheetPickerShown = false
	}

	func actionSheetPickerDidCancel(actionSheetPicker: AbstractActionSheetPicker!, origin: AnyObject!) {
		cancelBarButtonItemTapped()
		actionSheetPickerShown = false
	}

	@IBAction func scrollToTopButtonTapped() {
		self.tableView.setContentOffset(CGPointZero, animated: true)
	}

	var path: [CharacterListPickerItem] = []
	let pickers = [levelPicker, sortPicker, rarePicker, elementPicker,
		weaponPicker, typePicker]

	var pickerView: UIPickerView!

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

	func resetPath(item: CharacterListPickerItem) {
		path.removeAll(keepCapacity: true)
		path.append(item)
	}

	var numberOfComponents: Int {
		get {
			return picker(byComponent: 0).depth
		}
	}

	func picker(byComponent component: Int) -> CharacterListPickerItem {
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

	@IBAction func cancelBarButtonItemTapped() {
		for picker in pickers {
			picker.value = picker.originalValue
		}
	}

	@IBAction func resetBarButtonItemTapped() {
		picker(byComponent: 0).reset()
		confirmBarButtonItemTapped()
	}

	@IBAction func confirmBarButtonItemTapped() {
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

var thumbnailCache = [Int: UIImage]()
var defaultThumbnalCache: UIImage!

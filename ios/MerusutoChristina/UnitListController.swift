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
class UnitListController: UIViewController, ActionSheetCustomPickerDelegate, RESideMenuDelegate {

	@IBOutlet var loadingView: UIView!

	var allItems = [UnitItem]()
	var displayedItems: [UnitItem]?

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
				let item = UnitItem(data: each)
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

//		self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGestureRecognized:"))
		self.sideMenuViewController.panGestureEnabled = true
		self.sideMenuViewController.panFromEdge = false

//        self.sideMenuViewController.scaleContentView = false

		self.sideMenuViewController.contentViewShadowEnabled = true
		self.sideMenuViewController.contentViewShadowColor = UIColor.grayColor()
		self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(-10, 0)

		self.sideMenuViewController.parallaxEnabled = false
//		self.sideMenuViewController.contentViewInLandscapeOffsetCenterX = -200
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = 0
		self.sideMenuViewController.contentViewScaleValue = 1;
//		let width = self.view.frame.width * 0.4
//		let height = self.view.frame.height
//		self.frostedViewController.menuViewSize = CGSizeMake(width, height)

		self.sideMenuViewController.parallaxEnabled = true
//                self.sideMenuViewController.parallaxContentMinimumRelativeValue = 100

		self.sideMenuViewController.delegate = self

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drawer"), style: UIBarButtonItemStyle.Done, target: self, action: "menu_handler:")
	}

	func sideMenu(sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {

		print("drag \(self.sideMenuViewController.leftMenuViewController.view.transform)) \(self.sideMenuViewController.contentViewController.view.transform)")
	}

	func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
		print("drag \(self.sideMenuViewController.leftMenuViewController.view.transform)) \(self.sideMenuViewController.contentViewController.view.transform))")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func menu_handler(sender: AnyObject) {
//		self.frostedViewController.presentMenuViewController()
		self.sideMenuViewController.presentLeftMenuViewController()
	}

	func panGestureRecognized(sender: UIPanGestureRecognizer) {
		self.view.endEditing(true)

//		self.frostedViewController.view.endEditing(true)
//		self.frostedViewController.panGestureRecognized(sender)

//		print("\(self.frostedViewController.menuViewSize)")

		self.sideMenuViewController.view.endEditing(true)
	}

	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//		let width = self.view.frame.height * 0.4
//		let height = self.view.frame.width
//		self.frostedViewController.menuViewSize = CGSizeMake(width, height)
//		self.frostedViewController.resizeMenuViewControllerToSize(self.frostedViewController.menuViewSize)
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

		let item = displayedItems![indexPath.row] as UnitItem
		let cell = tableView.dequeueReusableCellWithIdentifier("Unit Item Cell", forIndexPath: indexPath)
		as! UnitItemCell
		cell.item = item

		return cell
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "Show Detail Segue") {
			let controller: UnitItemController = segue.destinationViewController as! UnitItemController
			let indexPath = tableView.indexPathForSelectedRow!
			controller.item = displayedItems![indexPath.row] as UnitItem
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

	var path: [UnitListPickerItem] = []
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

	func sort(var items: [UnitItem]) -> [UnitItem] {
//		print("in fun:\(unsafeAddressOf(items))")

		items.sortInPlace { (lhs: UnitItem, rhs: UnitItem) -> Bool in
			switch sortPicker.value
			{
			case 0:
				return lhs.rare > rhs.rare
			case 1:
				print("\(lhs.dps) and \(rhs.dps)")
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

	func filter(items: [UnitItem]) -> [UnitItem] {
		return items.filter({ (item: UnitItem) -> Bool in
			if rarePicker.check(item.rare) ||
			elementPicker.check(item.element) ||
			weaponPicker.check(item.weapon) ||
			typePicker.check(item.type) ||
			aareaPicker.check(item.aarea) ||
			anumPicker.check(item.anum) ||
			genderPicker.check(item.gender)
			{
				return false
			}
			return true
		})
	}

	func updateLevelMode(items: [UnitItem]) {
		if levelPicker.value != levelPicker.originalValue {
			for item in items {
				item.levelMode = levelPicker.value
			}
		}
	}

	func resetPath(item: UnitListPickerItem) {
		path.removeAll(keepCapacity: true)
		path.append(item)
	}

	var numberOfComponents: Int {
		get {
			return picker(byComponent: 0).depth
		}
	}

	func picker(byComponent component: Int) -> UnitListPickerItem {
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

class UnitItemCell: UITableViewCell {

	@IBOutlet var rareLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var thumbImageView: UIImageView!
	@IBOutlet var detailLabel1: UILabel!
	@IBOutlet var detailLabel2: UILabel!
	@IBOutlet var detailLabel3: UILabel!
	@IBOutlet var detailLabel4: UILabel!
	@IBOutlet var elementView: ElementView!

	var item: UnitItem! {
		didSet {
			let item = self.item

			rareLabel.text = item.rareString
			titleLabel.text = item.title + item.name
			detailLabel1.text = "生命: \(item.life)\n攻击: \(item.atk)\n攻距: \(item.aarea)\n攻数: \(item.anum)"
			detailLabel2.text = "攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
			detailLabel3.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%"
			detailLabel4.text = "暗: \(Int(item.dark * 100))%\n\nDPS: \(item.dps)\n总DPS: \(item.mdps)"
			elementView.item = item

			let imageUrl = DataManager.getGithubURL("units/thumbnail/\(item.id).png")
			print("load image with url \(imageUrl)")
			thumbImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "thumbnail"), options: SDWebImageOptions.RetryFailed)
		}
	}
}

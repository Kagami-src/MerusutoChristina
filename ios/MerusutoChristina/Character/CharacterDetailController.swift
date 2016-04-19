//
//  CharacterDetailController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit
import AVOSCloud
import SDWebImage
import MBProgressHUD

class CharacterDetailController: UIViewController, UIScrollViewDelegate {

	var scrollView: UIScrollView!
	var contentView: UIView!

	var imageViewer: ImageViewer!
	var propertyViewer: PropertyDetailView!

	var pageController: UIPageControl!
	var pageBeforeRotate: Int!

	var item: CharacterItem! {
		didSet {

			print("character didSet")

			let _ = self.view

			propertyViewer.item = item

			imageViewer.imageUrl = getItemUrl()

			setDetailFontSize()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		AVAnalytics.event("Open", label: "0 \(item.id)")

		scrollView = UIScrollView(frame: self.view.bounds)
		scrollView.backgroundColor = UIColor(red: 0.139, green: 0.137, blue: 0.142, alpha: 0.9)
		scrollView.pagingEnabled = true
		scrollView.delegate = self
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bounces = false
		self.view.addSubview(scrollView)

		contentView = UIView(frame: self.view.bounds)
		scrollView.addSubview(contentView)

		imageViewer = ImageViewer(frame: self.view.bounds)
		contentView.addSubview(imageViewer)

		propertyViewer = getPropertyDetailView()
		contentView.addSubview(propertyViewer)

		pageController = UIPageControl()
		pageController.numberOfPages = 2
		pageController.userInteractionEnabled = false
		self.view.addSubview(pageController)

		setConstraints()

		let gesture = UITapGestureRecognizer(target: self, action: Selector("tap_handler:"))
		self.view.addGestureRecognizer(gesture)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("imageViewer_handler:"), name: IMAGE_SCALE_SCROLLVIEW_ZOOMING, object: nil)
	}

	func getPropertyDetailView() -> PropertyDetailView {
		return CharacterPropertyView(frame: self.view.bounds)
	}

	func getItemUrl() -> NSURL {
		return DataManager.getGithubURL("units/original/\(item.id).png")
	}

	func setConstraints() {
		scrollView.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(self.view)
			make.right.equalTo(self.view)
			make.top.equalTo(self.view)
			make.bottom.equalTo(self.view)
		}

		contentView.snp_updateConstraints { (make) -> Void in
			make.edges.equalTo(scrollView)
			make.height.equalTo(scrollView)
			make.width.equalTo(scrollView).multipliedBy(2)
		}

		imageViewer.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(contentView.snp_left)
			make.top.equalTo(contentView.snp_top)
			make.bottom.equalTo(contentView.snp_bottom)
			make.width.equalTo(contentView).multipliedBy(0.5)
		}

		propertyViewer.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(imageViewer.snp_right)
			make.top.equalTo(imageViewer.snp_top).offset(20)
			make.bottom.equalTo(imageViewer.snp_bottom).offset(-20)
			make.width.equalTo(imageViewer.snp_width)
		}

		pageController.snp_makeConstraints { [unowned self](make) -> Void in
			make.centerX.equalTo(self.view.snp_centerX)
			make.bottom.equalTo(self.view.snp_bottom).offset(0)
			make.width.equalTo(80)
			make.height.equalTo(20)
		}
	}

	func imageViewer_handler(note: NSNotification) {
		self.scrollView.scrollEnabled = !imageViewer.isZoomImage
	}

	deinit {
		print("unit item dealloc")

		NSNotificationCenter.defaultCenter().removeObserver(self, name: IMAGE_SCALE_SCROLLVIEW_ZOOMING, object: nil)
	}

	func tap_handler(gesture: UITapGestureRecognizer) {

		self.dismissViewControllerAnimated(true, completion: nil)
	}

	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {

		pageBeforeRotate = pageController.currentPage

		UIView.animateWithDuration(0.15, animations: {
			self.imageViewer.alpha = 0
			self.propertyViewer.alpha = 0
			self.pageController.alpha = 0
		})
	}

	func setDetailFontSize() {

		let screenWidth: CGFloat = getScreenWidth()
		let screenHeight: CGFloat = getScreenHeight()

		// 不用UIDevice.currentDevice().orientation去判断，是因为会有isFalt的情况出现
		let isPortrait: Bool = screenWidth < screenHeight

		let fontSize: CGFloat = isPortrait ? screenWidth / 414.0 * 18.0 : screenWidth / 736 * 17.0

		self.propertyViewer.setFontSize(fontSize)
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {

		self.pageController.currentPage = self.pageBeforeRotate
		self.scrollView.setContentOffset(CGPointMake(self.scrollView.frame.width * CGFloat(self.pageBeforeRotate), 0), animated: false)

		UIView.animateWithDuration(0.25, animations: {
			self.imageViewer.alpha = 1
			self.propertyViewer.alpha = 1
			self.pageController.alpha = 1
		})

		imageViewer.calculateImageViewFrame()
		setDetailFontSize()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		imageViewer.calculateImageViewFrame()
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		pageController.currentPage = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width)
	}
}

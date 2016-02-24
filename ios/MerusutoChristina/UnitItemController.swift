//
//  UnitItemController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit
import AVOSCloud
import SDWebImage
import MBProgressHUD

class UnitItemController: UIViewController {
	var item: UnitItem!

	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var pageControl: UIPageControl!
	@IBOutlet var loadingView: UIView!

	var detailView: UIView!
	var imageView: UIImageView!
	var pageViews: [UIView?] = []

	var minZoomScale: CGFloat?
	var maxZoomScale: CGFloat?
	var zoomEnabled = true

	func CGFloatInLine(value: Float) -> Float
	{
		let scale: Float = Float(UIScreen.mainScreen().bounds.size.width) / 375
		return scale * value
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		AVAnalytics.event("Open", label: "0 \(item.id)")

//		scrollView.frame = view.frame
		scrollView.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 20)
		scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * 2, 0)
		scrollView.backgroundColor = UIColor.greenColor()
		scrollView.clipsToBounds = true

		let detailController = storyboard?.instantiateViewControllerWithIdentifier("Detail View Controller") as! UnitItemDetailController

		print(self.item)
		detailController.item = item

		detailView = detailController.view
		scrollView.addSubview(detailView)
		calculateDetailViewFrame()

		pageViews = [imageView, detailView]

		forceEnablePaging()
		loadVisiblePages()

		// 定义MBProgressHUD对象
		let hud: MBProgressHUD = MBProgressHUD(view: self.view)
		hud.show(true)
		hud.labelText = "立绘加载中..."
		hud.removeFromSuperViewOnHide = true
		hud.mode = MBProgressHUDMode.Determinate
		hud.backgroundColor = UIColor.clearColor()
		hud.color = UIColor.clearColor()
		hud.userInteractionEnabled = false
		self.scrollView.addSubview(hud)

		let imageUrl = DataManager.getGithubURL("units/original/\(item.id).png")
		self.imageView = UIImageView()
		self.imageView.sd_setImageWithURL(imageUrl, placeholderImage: nil, options: SDWebImageOptions.ProgressiveDownload, progress: {
			(receivedSize: Int, totalSize: Int) -> Void in

			// 计算下载进度
			print("id:\(self.item.id) \(receivedSize)/\(totalSize)")
			hud.progress = (Float(receivedSize) / Float(totalSize))
			}, completed: {
			(image: UIImage!, error: NSError!, type, url: NSURL!) -> Void in

			self.imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
			self.scrollView.addSubview(self.imageView)
			self.scrollView.contentSize = image.size
			self.imageView.alpha = 0
			self.imageView.backgroundColor = UIColor.redColor()

			UIView.animateWithDuration(0.25, animations: { () -> Void in
				self.imageView.alpha = 1
			})

			hud.hide(true)

			self.calculateImageViewFrame()
		})
	}

	deinit {
		print("unit item dealloc")
	}

	func calculateImageViewFrame() {
		let frameSize = scrollView.frame.size
		let contentSize = imageView.bounds.size
		let scaleWidth = frameSize.width / contentSize.width
		let scaleHeight = frameSize.height / contentSize.height
		minZoomScale = min(scaleWidth, scaleHeight)

		scrollView.minimumZoomScale = minZoomScale!
		scrollView.zoomScale = minZoomScale!

		forceEnablePaging()
		centerScrollViewContents()
	}

	func calculateDetailViewFrame() {
		var frame = view.frame
		frame.origin.x = frame.width
		detailView.frame = frame
	}

	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {

		print(UIScreen.mainScreen().bounds)
		print("2:\(scrollView.frame)")

		UIView.animateWithDuration(0.25, animations: {
			self.imageView.alpha = 0
			self.detailView.alpha = 0
		})
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		UIView.animateWithDuration(0.25, animations: {
			self.imageView.alpha = 1
			self.detailView.alpha = 1
		})

		print(UIScreen.mainScreen().bounds)
		print("2:\(scrollView.frame)")

		calculateImageViewFrame()
		calculateDetailViewFrame()
	}

	func loadVisiblePages() {
		// First, determine which page is currently visible
		let pageWidth = scrollView.frame.size.width
		let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))

		// Update the page control
		pageControl.currentPage = page
	}

	func forceEnablePaging() {
		scrollView.pagingEnabled = true

		let frameSize = scrollView.frame.size
		scrollView.contentSize = CGSizeMake(frameSize.width * CGFloat(pageViews.count),
			frameSize.height)

		print("__func__ \(frameSize)")

		detailView.alpha = 0
		UIView.animateWithDuration(0.25, animations: {
			self.pageControl.alpha = 1
			self.detailView.alpha = 1
		})
	}

	func enablePaging() {
		if !scrollView.pagingEnabled {
			forceEnablePaging()
		}
	}

	func disablePaging() {
		if scrollView.pagingEnabled {
			scrollView.pagingEnabled = false
			scrollView.contentSize = imageView.frame.size

			detailView.alpha = 0
			UIView.animateWithDuration(0.25, animations: {
				self.pageControl.alpha = 0
			})
		}
	}

	func enableZoom() {
		if !zoomEnabled {
			zoomEnabled = true

			scrollView.maximumZoomScale = maxZoomScale!
			scrollView.minimumZoomScale = minZoomScale!
		}
	}

	func disableZoom() {
		if scrollView.contentOffset.x >= scrollView.frame.size.width && zoomEnabled {
			zoomEnabled = false

			maxZoomScale = scrollView.maximumZoomScale
			minZoomScale = scrollView.minimumZoomScale
			scrollView.maximumZoomScale = 1.0
			scrollView.minimumZoomScale = 1.0
		}
	}

	@IBAction func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
		let pointInView = recognizer.locationInView(self.imageView)

		var newZoomScale = scrollView.zoomScale * 1.5
		newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)

		let scrollViewSize = scrollView.bounds.size
		let w = scrollViewSize.width / newZoomScale
		let h = scrollViewSize.height / newZoomScale
		let x = pointInView.x - (w / 2.0)
		let y = pointInView.y - (h / 2.0)

		let rectToZoomTo = CGRectMake(x, y, w, h)
		scrollView.zoomToRect(rectToZoomTo, animated: true)
	}

	func centerScrollViewContents() {
		let boundsSize = scrollView.frame.size
		var contentsFrame = imageView.frame

		if contentsFrame.size.width < boundsSize.width {
			contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
		} else {
			contentsFrame.origin.x = 0.0
		}

		if contentsFrame.size.height < boundsSize.height {
			contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
		} else {
			contentsFrame.origin.y = 0.0
		}

		imageView.frame = contentsFrame
	}

	func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
		return imageView
	}

	func scrollViewDidZoom(scrollView: UIScrollView!) {

        centerScrollViewContents()

		print(scrollView.contentOffset)
		if scrollView.zoomScale == scrollView.minimumZoomScale {
			enablePaging()
		} else {
			disablePaging()
		}
	}

	func scrollViewDidScroll(scrollView: UIScrollView!) {
		// Load the pages that are now on screen
		loadVisiblePages()
		if imageView == nil || scrollView.contentOffset.x >= imageView.frame.size.width {
			disableZoom()
		} else {
			enableZoom()
		}
	}

	@IBAction func viewTapped() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

class UnitItemDetailController: UIViewController {

	@IBOutlet var rareLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var detailLabel1: UILabel!
	@IBOutlet var detailLabel2: UILabel!
	@IBOutlet var detailLabel3: UILabel!
	@IBOutlet var detailLabel4: UILabel!
	@IBOutlet var detailLabel5: UILabel!
	@IBOutlet var detailLabel6: UILabel!
	@IBOutlet var detailLabel7: UILabel!
	@IBOutlet var detailLabel8: UILabel!
	@IBOutlet var detailLabel9: UILabel!

	var item: UnitItem! {
		didSet {
			let view = self.view

			rareLabel.text = item.rareString
			titleLabel.text = "\(item.title)\(item.name) ID: \(item.id)"

			let atk0 = item.originalAtk
			let life0 = item.originalLife
			let dps0 = item.calcDPS(atk0)
			let mdps0 = item.calcMDPS(atk0)

			let atk1 = item.calcMaxLv(atk0)
			let life1 = item.calcMaxLv(life0)
			let dps1 = item.calcDPS(atk1)
			let mdps1 = item.calcMDPS(atk1)

			let atk2 = item.calcMaxLvAndGrow(atk0)
			let life2 = item.calcMaxLvAndGrow(life0)
			let dps2 = item.calcDPS(atk2)
			let mdps2 = item.calcMDPS(atk2)

			detailLabel1.text = "初始生命: \(life0)\n满级生命: \(life1)\n满觉生命: \(life2)\n初始攻击: \(atk0)\n满级攻击: \(atk1)\n满觉攻击: \(atk2)"
			detailLabel2.text = "攻距: \(item.aarea)\n攻数: \(item.anum)\n攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
			detailLabel3.text = "初始DPS: \(dps0)\n满级DPS: \(dps1)\n满觉DPS: \(dps2)\n初始总DPS: \(mdps0)\n满级总DPS: \(mdps1)\n满觉总DPS: \(mdps2)"
			detailLabel4.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%\n暗: \(Int(item.dark * 100))%"
			detailLabel5.text = "国家: \(item.country)\n性别: \(item.genderString)\n年龄: \(item.ageString)"
			detailLabel6.text = "职业: \(item.career)\n兴趣: \(item.interest)\n性格: \(item.nature)"
			detailLabel7.text = item.obtain.characters.count > 0 ? "获取方式: \(item.obtain)" : ""
			detailLabel8.text = item.remark.characters.count > 0 ? "备注: \(item.remark)" : ""
			detailLabel9.text = item.contributorsString.characters.count > 0 ? "数据提供者: \(item.contributorsString)" : ""
		}
	}
}
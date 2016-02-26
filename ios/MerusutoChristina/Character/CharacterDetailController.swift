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

class CharacterDetailController: UIViewController {
	var item: CharacterItem!

	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var pageControl: UIPageControl!
	@IBOutlet var loadingView: UIView!

	var detailView: UIView!
	var imageView: UIImageView!
	var pageViews: [UIView?] = []

	var minZoomScale: CGFloat?
	var maxZoomScale: CGFloat?
	var zoomEnabled = true

	var pageBeforeRotate: Int = 0

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
//		scrollView.clipsToBounds = true

		print("scrollview frame:\(scrollView.frame)")

		let detailController = storyboard?.instantiateViewControllerWithIdentifier("Character Property Detail View Controller") as! CharacterPropertyDetailController
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

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		print("scrollView frame after layout:\(scrollView.frame)")

        calculateImageViewFrame()
        calculateDetailViewFrame()
	}

	func calculateImageViewFrame() {

		let frameSize = scrollView.frame.size
		let contentSize = imageView.bounds.size
		let scaleWidth = frameSize.width / contentSize.width
		let scaleHeight = frameSize.height / contentSize.height
		minZoomScale = min(scaleWidth, scaleHeight)
		print("scrollView frame:\(scrollView.frame)")
		print("contentSize frame:\(contentSize)")
		print("min zoom:\(minZoomScale)")
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
        
		pageBeforeRotate = pageControl.currentPage
        
		UIView.animateWithDuration(0.15, animations: {
			self.imageView.alpha = 0
			self.detailView.alpha = 0
		})
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
		self.pageControl.currentPage = self.pageBeforeRotate
		self.scrollView.setContentOffset(CGPointMake(self.scrollView.frame.width * CGFloat(self.pageBeforeRotate), 0), animated: false)

		UIView.animateWithDuration(0.25, animations: {
			self.imageView.alpha = 1
			self.detailView.alpha = 1
		})

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
		scrollView.contentSize = CGSizeMake(frameSize.width * CGFloat(pageViews.count), frameSize.height)

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
			contentsFrame.origin.x = 0
		}

		if contentsFrame.size.height < boundsSize.height {
			contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
		} else {
			contentsFrame.origin.y = 0
		}

		imageView.frame = contentsFrame
		print("imageView frame:\(imageView.frame)")
	}

	func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
		return imageView
	}

	func scrollViewDidZoom(scrollView: UIScrollView!) {

		centerScrollViewContents()

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


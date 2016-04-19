//
//  RootViewController.swift
//  MerusutoChristina
//
//
//  主容器，处理菜单ViewController和内容ViewController
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import RESideMenu
import SDWebImage
import MBProgressHUD
import Reachability

class RootViewController: RESideMenu, SDWebImagePrefetcherDelegate {

	var mainTabBarController: UITabBarController?
	var hud: MBProgressHUD!
	var hudTapGesture: UITapGestureRecognizer!

	var isBackgroundDownloading = false
	var isDownloading = false
	typealias MyBlock = () -> Void

	override func awakeFromNib()
	{
		self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contentController")
		self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("menuController")

		self.mainTabBarController = self.contentViewController as? UITabBarController

		self.backgroundImage = UIImage(named : "Stars")

		// 定义SideMenu的样式
		self.panGestureEnabled = true
		self.panFromEdge = false

		self.contentViewShadowEnabled = true
		self.contentViewShadowColor = UIColor.grayColor()
		self.contentViewShadowOffset = CGSizeMake(-10, 0)

        
        let minValue = min(getScreenWidth(),getScreenHeight())
        let maxValue = max(getScreenWidth(),getScreenHeight())
		self.contentViewInPortraitOffsetCenterX = minValue * 0.1
        self.contentViewInLandscapeOffsetCenterX = maxValue * -0.1
		self.contentViewScaleValue = 1;
		self.scaleMenuView = false

		// 定义 hud
		hud = MBProgressHUD(view: self.view)
		hud.userInteractionEnabled = true
		self.hudTapGesture = UITapGestureRecognizer(target: self, action: Selector("hud_clickHandler:"))
		hud.addGestureRecognizer(hudTapGesture)
		self.view.addSubview(hud!)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("background_handler:"), name: UIApplicationWillEnterForegroundNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("background_handler:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loading_handler:"), name: ROOT_SHOW_LOADING, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loading_handler:"), name: ROOT_HIDE_LOADING, object: nil)
	}

	func loading_handler(sender: NSNotification) {
		print(sender.name)
		if (sender.name == ROOT_SHOW_LOADING) {
			hud.mode = MBProgressHUDMode.Indeterminate
			hud.show(true)
			hud.labelText = "加载中..."
			hud.detailsLabelText = ""

			hudTapGesture.enabled = false
			self.panGestureEnabled = false
		}
		else if (sender.name == ROOT_HIDE_LOADING) {

			hudTapGesture.enabled = true
			self.panGestureEnabled = true

			hud.hide(true)
		}
	}

	func background_handler(sender: AnyObject) {

		if (sender.name == UIApplicationDidEnterBackgroundNotification) {
			SDWebImagePrefetcher.sharedImagePrefetcher().cancelPrefetching()
			self.hud.hide(false)

			self.isBackgroundDownloading = false
		}
		else {
			if (self.isDownloading) {
				downloadAllResource()
			}
		}
	}

	deinit {

		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
	}

	func hud_clickHandler(sender: UITapGestureRecognizer) {
		self.isBackgroundDownloading = true
		self.hud.hide(true)
		self.hud.userInteractionEnabled = false
		self.panGestureEnabled = true

		SDWebImagePrefetcher.sharedImagePrefetcher().options = [SDWebImageOptions.LowPriority, SDWebImageOptions.ProgressiveDownload, SDWebImageOptions.ContinueInBackground]
	}

	func switchToController(let index : Int)
	{
		self.mainTabBarController!.selectedIndex = index;

		self.hideMenuViewController()
	}

	func downloadAllResource() {

		self.hideMenuViewController()

		self.hud.userInteractionEnabled = true
		self.panGestureEnabled = false

		if (self.isBackgroundDownloading) {
			self.hud.show(true)
			self.hud.mode = MBProgressHUDMode.DeterminateHorizontalBar
			self.isBackgroundDownloading = false
			return;
		}

		if (Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi) {
			print("not wifi")
			self.hud.show(true)
			self.hud.mode = MBProgressHUDMode.Text
			self.hud.labelText = "请在WIFI下再试"
			self.hud.hide(true, afterDelay: 1.5)
			return;
		}

		// for test
		#if DEBUG
			SDImageCache.sharedImageCache().clearDisk()
			SDImageCache.sharedImageCache().clearMemory()
		#endif

		SDWebImagePrefetcher.sharedImagePrefetcher().options = [SDWebImageOptions.HighPriority, SDWebImageOptions.ProgressiveDownload, SDWebImageOptions.ContinueInBackground]

		var thumbnails: Array<NSURL> = Array() // 人物小图
		var originals: Array<NSURL> = Array() // 人物原图

		self.hud.show(true)
		self.hud.labelText = "优君正在统计后宫名单..."
		self.hud.detailsLabelText = ""
		self.isDownloading = true;

		DataManager.loadJSONWithSuccess("units", success: { (data) -> Void in
			for (_, each) in data {
				let item = CharacterItem(data: each)

				let thumbnailUrl = DataManager.getGithubURL("units/thumbnail/\(item.id).png")
				if (!SDWebImageManager.sharedManager().diskImageExistsForURL(thumbnailUrl)) {
					thumbnails.append(thumbnailUrl)
				}

				let originalURL = DataManager.getGithubURL("units/original/\(item.id).png")
				if (!SDWebImageManager.sharedManager().diskImageExistsForURL(originalURL)) {
					originals.append(originalURL)
				}
			}
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.prefetchImage("下载小图，主人请耐心等待", target: thumbnails, backFun: { () -> Void in

					self.prefetchImage("下载原图，主人请耐心等待", target: originals, backFun: { () -> Void in

						self.hud.mode = MBProgressHUDMode.Text
						self.hud.labelText = "下载完毕！"
						self.hud.detailsLabelText = ""

						self.hud.hide(true, afterDelay: 1.0)

						self.panGestureEnabled = true
						self.isBackgroundDownloading = false
						self.isDownloading = false
					})
				})
			})
		})
	}

	func prefetchImage(text: String, target: Array<NSURL>, backFun: MyBlock?) {

		self.hud.mode = MBProgressHUDMode.DeterminateHorizontalBar
		self.hud.labelText = text
		self.hud.progress = 0
		self.hud.detailsLabelText = "0 / \(target.count)"

		SDWebImagePrefetcher.sharedImagePrefetcher().prefetchURLs(target, progress: { (bytesLoad: UInt, totalBytes: UInt) -> Void in

			if (self.isNetworkFail() == true) {

				print("网络错误，退出下载")
				SDWebImagePrefetcher.sharedImagePrefetcher().cancelPrefetching()

				self.hud.show(true)
				self.hud.mode = MBProgressHUDMode.Text
				self.hud.labelText = "网络错误！"
				self.hud.hide(true, afterDelay: 1.5)

				if (backFun != nil) {
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						backFun!()
					})
				}

				return;
			}

			self.hud.progress = Float(bytesLoad) / Float(totalBytes)
			self.hud.labelText = text
			self.hud.detailsLabelText = "\(bytesLoad) / \(totalBytes)（点击后台下载）"
		}) { (value1: UInt, value2: UInt) -> Void in
			if (backFun != nil) {
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					backFun!()
				})
			}
		}
	}

	func clearAllResource() {
		SDWebImagePrefetcher.sharedImagePrefetcher().cancelPrefetching();

		print(NSThread.currentThread())

		SDImageCache.sharedImageCache().clearMemory();

		self.hud.show(true)
		self.hud.labelText = "优君正在开除后宫..."
		self.isBackgroundDownloading = false
		self.isDownloading = false

		self.hideMenuViewController()

		SDImageCache.sharedImageCache().clearDiskOnCompletion { () -> Void in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.hud.hide(true, afterDelay: 1.5)
			})
		}
	}

	func isNetworkFail() -> Bool {
		return Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi
	}
}

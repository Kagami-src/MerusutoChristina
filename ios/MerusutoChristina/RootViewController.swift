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
	var hud: MBProgressHUD?
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

		self.contentViewInPortraitOffsetCenterX = UIScreen.mainScreen().bounds.width * (0.6 - 0.5)
		self.contentViewScaleValue = 1;
		self.scaleMenuView = false

		hud = MBProgressHUD(view: self.view)
		hud?.userInteractionEnabled = true
//        hud?.removeFromSuperViewOnHide = true
		self.view.addSubview(hud!)
	}


	func switchToController(let index : Int)
	{
		self.mainTabBarController!.selectedIndex = index;

		self.hideMenuViewController()
	}

	func downloadAllResource() {

		self.hideMenuViewController()
        self.panGestureEnabled = false
        
		if (Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi) {
			print("not wifi")
			self.hud?.show(true)
			self.hud?.mode = MBProgressHUDMode.Text
			self.hud?.labelText = "请在WIFI下再试"
			self.hud?.hide(true, afterDelay: 1.5)
			return;
		}

		// for test
//		SDImageCache.sharedImageCache().clearDisk()
//		SDImageCache.sharedImageCache().clearMemory()

		SDWebImagePrefetcher.sharedImagePrefetcher().delegate = self
		SDWebImagePrefetcher.sharedImagePrefetcher().options = [SDWebImageOptions.HighPriority, SDWebImageOptions.ProgressiveDownload]

		var thumbnails: Array<NSURL> = Array() // 人物小图
		var originals: Array<NSURL> = Array() // 人物原图

		self.hud?.show(true)
		self.hud?.labelText = "正在统计需要下载的文件"

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
				self.prefetchImage("正在下载人物小图", target: thumbnails, backFun: { () -> Void in

					self.prefetchImage("正在下载人物原图", target: originals, backFun: { () -> Void in

						self.hud?.mode = MBProgressHUDMode.Text
						self.hud?.labelText = "下载完毕！"
						self.hud?.detailsLabelText = ""

						self.hud?.hide(true, afterDelay: 1.0)
                        
                        self.panGestureEnabled = true
					})
				})
			})
		})
	}

	func prefetchImage(text: String, target: Array<NSURL>, backFun: MyBlock?) {

		self.hud?.mode = MBProgressHUDMode.DeterminateHorizontalBar
		self.hud?.labelText = text
		self.hud?.progress = 0
		self.hud?.detailsLabelText = "0 / \(target.count)"

		SDWebImagePrefetcher.sharedImagePrefetcher().prefetchURLs(target, progress: { (bytesLoad: UInt, totalBytes: UInt) -> Void in

			if (self.isNetworkFail() == true) {

				print("网络错误，退出下载")
				SDWebImagePrefetcher.sharedImagePrefetcher().cancelPrefetching()

				self.hud?.show(true)
				self.hud?.mode = MBProgressHUDMode.Text
				self.hud?.labelText = "网络错误！"
				self.hud?.hide(true, afterDelay: 1.5)

				if (backFun != nil) {
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						backFun!()
					})
				}

				return;
			}

			self.hud?.progress = Float(bytesLoad) / Float(totalBytes)
			self.hud?.detailsLabelText = "\(bytesLoad) / \(totalBytes)"
		}) { (value1: UInt, value2: UInt) -> Void in
			if (backFun != nil) {
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					backFun!()
				})
			}
		}
	}

	func isNetworkFail() -> Bool {
//
//		let gitReach = Reachability(hostName: "bbtfr.github.io")
//        let test = gitReach.currentReachabilityStatus()
//		let req = gitReach.connectionRequired()
//		print("req:\(req)")

		return Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi
	}

	func imagePrefetcher(imagePrefetcher: SDWebImagePrefetcher!, didPrefetchURL imageURL: NSURL!, finishedCount: UInt, totalCount: UInt) {
//		print("finish \(imageURL) \(finishedCount) \(totalCount)")
	}

	func imagePrefetcher(imagePrefetcher: SDWebImagePrefetcher!, didFinishWithTotalCount totalCount: UInt, skippedCount: UInt) {
	}
}

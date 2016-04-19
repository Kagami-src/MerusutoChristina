//
//  ImageViewer.swfit
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/12.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class ImageViewer: UIScrollView, UIScrollViewDelegate {

	var hud: MBProgressHUD!

	var isZoomImage: Bool = false
    
	var minZoomScale: CGFloat!

	var imageView: UIImageView!

	var imageUrl: NSURL! {
		didSet {
            
            print("imageUrl didSet")
			self.hud.show(true)

			self.imageView.sd_setImageWithURL(imageUrl, placeholderImage: nil, options: [SDWebImageOptions.ProgressiveDownload, SDWebImageOptions.RetryFailed], progress: {
				(receivedSize: Int, totalSize: Int) -> Void in

				// 计算下载进度
				// print("id:\(self.item.id) \(receivedSize)/\(totalSize)")
				self.hud.progress = (Float(receivedSize) / Float(totalSize))
                
				}, completed: { (image: UIImage!, error: NSError!, type, url: NSURL!) -> Void in

				print("\(__FUNCTION__) \(image) \(self.imageUrl)")
				if (error != nil || image == nil)
				{
					self.hud.labelText = "加载失败..."
					print("网络错误 \(error)")
					return;
				}

				self.imageView.image = image
				self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)

				self.calculateImageViewFrame();

				self.hud.hide(true)

				UIView.animateWithDuration(0.25, animations: { () -> Void in
					self.imageView.alpha = 1
				})
			})
		}
	}

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.delegate = self

		self.imageView = UIImageView()
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView)

		self.hud = MBProgressHUD(view: self)
		self.hud.labelText = "立绘加载中..."
		self.hud.mode = MBProgressHUDMode.Determinate
		self.hud.backgroundColor = UIColor.clearColor()
		self.hud.color = UIColor.clearColor()
		self.addSubview(hud)
		self.hud.hide(false)
	}

	func calculateImageViewFrame() {
		if (imageView.image == nil) {
			return;
		}

		let frameSize = self.frame.size
		let contentSize = imageView.image!.size
		let scaleWidth = frameSize.width / contentSize.width
		let scaleHeight = frameSize.height / contentSize.height
		self.minZoomScale = min(scaleWidth, scaleHeight)

		self.minimumZoomScale = minZoomScale
		self.zoomScale = minZoomScale

		NSNotificationCenter.defaultCenter().postNotificationName(IMAGE_SCALE_SCROLLVIEW_ZOOMING, object: self)

		centerScrollViewContents()
	}

	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}

	func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
		isZoomImage = false

		self.bounces = true

		NSNotificationCenter.defaultCenter().postNotificationName(IMAGE_SCALE_SCROLLVIEW_ZOOMING, object: self)
	}

	func scrollViewDidZoom(scrollView: UIScrollView) {

		centerScrollViewContents()
	}

	func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {

		isZoomImage = self.zoomScale != self.minimumZoomScale

		self.bounces = isZoomImage

		NSNotificationCenter.defaultCenter().postNotificationName(IMAGE_SCALE_SCROLLVIEW_ZOOMING, object: self)
	}

	func centerScrollViewContents() {
		let boundsSize = self.frame.size
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

		self.imageView.frame = contentsFrame
	}

}

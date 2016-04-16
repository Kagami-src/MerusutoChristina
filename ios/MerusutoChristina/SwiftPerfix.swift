//
//  SwiftPerfix.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import Foundation
import UIKit

func getScreen() -> CGSize {
	return UIScreen.mainScreen().bounds.size;
}

func getScreenWidth() -> CGFloat {
	return getScreen().width
}

func getScreenHeight() -> CGFloat {
	return getScreen().height
}

func getStringWidth(value: String, font: UIFont) -> CGFloat {

	let temp: NSString = NSString(string: value)

	let bounds = temp.boundingRectWithSize(CGSizeMake(CGFloat.max, 1), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

	return bounds.width
}

//		 不用UIDevice.currentDevice().orientation去判断，是因为会有isFalt的情况出现
func getIsPortrait() -> Bool {
	let screenWidth: CGFloat = getScreenWidth()
	let screenHeight: CGFloat = getScreenHeight()

	return screenWidth < screenHeight
}

public let IMAGE_SCALE_SCROLLVIEW_ZOOMING = "image.scale.scrollview.zooming"
public let ROOT_SHOW_LOADING = "root.show.loading"
public let ROOT_HIDE_LOADING = "root.hide.loading"

func postShowLoading() {
	NSNotificationCenter.defaultCenter().postNotificationName(ROOT_SHOW_LOADING, object: nil)
}

func postHideLoading() {
	NSNotificationCenter.defaultCenter().postNotificationName(ROOT_HIDE_LOADING, object: nil)
}
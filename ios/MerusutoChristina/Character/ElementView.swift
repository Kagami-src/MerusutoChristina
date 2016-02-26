//
//  ElementView.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/26.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit

class ElementView: UIView {

	var item: CharacterItem? {
		didSet {
			setNeedsDisplay()
		}
	}

//  required init(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }

	override func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		let radius = min(rect.width, rect.height) / 2 - 5
		drawPentagonPointsTo(context!, boundedBy: rect, radius: radius, circleRadius: 3)
		drawPentagonTo(context!, boundedBy: rect, radius: radius, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
		drawPentagonTo(context!, boundedBy: rect, radius: radius * 2 / 3, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
		drawPentagonTo(context!, boundedBy: rect, radius: radius / 3, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
		drawElementTo(context!, boundedBy: rect, radius: radius)
	}

	func drawPentagonTo(context: CGContextRef, boundedBy rect: CGRect, radius: CGFloat, color: UIColor) {
		let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
		CGContextSetFillColorWithColor(context, color.CGColor)
		for i in 0 ... 4 {
			let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
			let x = center.x + radius * cos(angle)
			let y = center.y + radius * sin(angle)
			if i == 0 {
				CGContextMoveToPoint(context, x, y)
			} else {
				CGContextAddLineToPoint(context, x, y)
			}
		}
		CGContextFillPath(context)
	}

	func drawPentagonPointsTo(context: CGContextRef, boundedBy rect: CGRect, radius: CGFloat, circleRadius r: CGFloat) {
		let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
		for i in 0 ... 4 {
			let color = UIColorFromRGBA([0xffe74c3c, 0xff3498db, 0xff2ecc71, 0xfff1c40f, 0xff9b59b6][i])
			CGContextSetFillColorWithColor(context, color.CGColor)
			let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
			let x = center.x + radius * cos(angle)
			let y = center.y + radius * sin(angle)
			let circleRect = CGRectMake(x - r, y - r, 2 * r, 2 * r)
			CGContextFillEllipseInRect(context, circleRect)
			CGContextFillPath(context)
		}
	}

	func UIColorFromRGBA(rgbValue: UInt) -> UIColor {
		return UIColor(
			red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x000000FF) / 255.0,
			alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
		)
	}

	func drawElementTo(context: CGContextRef, boundedBy rect: CGRect, radius: CGFloat) {
		if let item = self.item {
			let elements = [item.fire, item.aqua, item.wind, item.light, item.dark]
			let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
			let color = UIColorFromRGBA([0, 0x80e74c3c, 0x803498db, 0x802ecc71, 0x80f1c40f, 0x809b59b6][item.element])
			CGContextSetFillColorWithColor(context, color.CGColor)
			for i in 0 ... 4 {
				let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
				let x = center.x + radius * cos(angle) * CGFloat(elements[i]) / 2
				let y = center.y + radius * sin(angle) * CGFloat(elements[i]) / 2
				if i == 0 {
					CGContextMoveToPoint(context, x, y)
				} else {
					CGContextAddLineToPoint(context, x, y)
				}
			}
			CGContextFillPath(context)
		}
	}
}
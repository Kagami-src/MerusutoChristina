//
//  CharacterPropertyDetailController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/24.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class CharacterPropertyDetailController: UIViewController {

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

	var item: CharacterItem! {
		didSet {
			let _ = self.view // 调用一下self.view为的是强制使ViewController完成viewDidLoad

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

			rareLabel.text = item.rareString + "  \(item.title)\(item.name) ID: \(item.id)"
//			titleLabel.text =

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

	func setFontSize(value: CGFloat) {
        print("set font size:\(value)")
		let font: UIFont = UIFont.boldSystemFontOfSize(value)

		rareLabel.font = font
		titleLabel.font = font

		detailLabel1.font = font
		detailLabel2.font = font
		detailLabel3.font = font
		detailLabel4.font = font
		detailLabel5.font = font
		detailLabel6.font = font
		detailLabel7.font = font
		detailLabel8.font = font
		detailLabel9.font = font
	}
}
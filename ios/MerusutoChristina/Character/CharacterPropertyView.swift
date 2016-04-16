//
//  CharacterPropertyDetailController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/24.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class CharacterPropertyView: PropertyDetailView {

	var titleLabel1: UILabel!
	var titleLabel2: UILabel!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!
	var detailLabel4: UILabel!
	var detailLabel5: UILabel!
	var detailLabel6: UILabel!
	var detailLabel7: UILabel!
	var detailLabel8: UILabel!
	var detailLabel9: UILabel!

	var contentView: UIView!

	override var item: CharacterItem! {
		didSet {
//			let _ = self.view // 调用一下self.view为的是强制使ViewController完成viewDidLoad

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

			titleLabel1.text = item.rareString + "  \(item.title)\(item.name)"
			titleLabel2.text = "ID: \(item.id)"

			detailLabel1.text = "初始生命: \(life0)\n满级生命: \(life1)\n满觉生命: \(life2)\n初始攻击: \(atk0)\n满级攻击: \(atk1)\n满觉攻击: \(atk2)"
			detailLabel2.text = "攻距: \(item.aarea)\n攻数: \(item.anum)\n攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
			detailLabel3.text = "初始DPS: \(dps0)\n满级DPS: \(dps1)\n满觉DPS: \(dps2)\n初始总DPS: \(mdps0)\n满级总DPS: \(mdps1)\n满觉总DPS: \(mdps2)"
			detailLabel4.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%\n暗: \(Int(item.dark * 100))%\n攻击段数: \(item.hits)"
			detailLabel5.text = "国家: \(item.country)\n性别: \(item.genderString)\n年龄: \(item.ageString)"
			detailLabel6.text = "职业: \(item.career)\n兴趣: \(item.interest)\n性格: \(item.nature)"
			detailLabel7.text = item.obtain.characters.count > 0 ? "获取方式: \(item.obtain)" : ""
			detailLabel8.text = item.remark.characters.count > 0 ? "备注: \(item.remark)" : ""
			detailLabel9.text = item.contributorsString.characters.count > 0 ? "数据提供者: \(item.contributorsString)" : ""
		}
	}

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override func setFontSize(value: CGFloat) {

		let font: UIFont = UIFont.boldSystemFontOfSize(value)

		titleLabel2.font = font
		titleLabel1.font = font

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

	override init(frame: CGRect) {
		super.init(frame: frame)

		// self.backgroundColor = UIColor.cyanColor()

		contentView = UIView()
		// contentView.backgroundColor = UIColor.blueColor()
		self.addSubview(contentView)

		titleLabel1 = UILabel();
		titleLabel2 = UILabel()
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();
		detailLabel4 = UILabel();
		detailLabel5 = UILabel();
		detailLabel6 = UILabel();
		detailLabel7 = UILabel();
		detailLabel8 = UILabel();
		detailLabel9 = UILabel();

		contentView.addSubview(titleLabel1)
		contentView.addSubview(titleLabel2)
		contentView.addSubview(detailLabel1)
		contentView.addSubview(detailLabel2)
		contentView.addSubview(detailLabel3)
		contentView.addSubview(detailLabel4)
		contentView.addSubview(detailLabel5)
		contentView.addSubview(detailLabel6)
		contentView.addSubview(detailLabel7)
		contentView.addSubview(detailLabel8)
		contentView.addSubview(detailLabel9)

//		titleLabel1.backgroundColor = UIColor.greenColor()
//		 rareLabel.backgroundColor = UIColor.redColor()
//		 detailLabel1.backgroundColor = UIColor.redColor()
//		 detailLabel2.backgroundColor = UIColor.yellowColor()
//		 detailLabel3.backgroundColor = UIColor.blueColor()
//		 detailLabel4.backgroundColor = UIColor.greenColor()
//		 detailLabel5.backgroundColor = UIColor.yellowColor()
//		 detailLabel6.backgroundColor = UIColor.purpleColor()
//		 detailLabel7.backgroundColor = UIColor.orangeColor()
//		 detailLabel8.backgroundColor = UIColor.greenColor()
//		 detailLabel9.backgroundColor = UIColor.greenColor()

		titleLabel1.numberOfLines = 0;
		titleLabel2.numberOfLines = 0;
		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
		detailLabel4.numberOfLines = 0;
		detailLabel5.numberOfLines = 0;
		detailLabel6.numberOfLines = 0;
		detailLabel7.numberOfLines = 0;
		detailLabel8.numberOfLines = 0;
		detailLabel9.numberOfLines = 0;

		titleLabel1.textColor = UIColor.lightTextColor()
		titleLabel2.textColor = UIColor.lightTextColor()
		detailLabel1.textColor = UIColor.lightTextColor()
		detailLabel2.textColor = UIColor.lightTextColor()
		detailLabel3.textColor = UIColor.lightTextColor()
		detailLabel4.textColor = UIColor.lightTextColor()
		detailLabel5.textColor = UIColor.lightTextColor()
		detailLabel6.textColor = UIColor.lightTextColor()
		detailLabel7.textColor = UIColor.lightTextColor()
		detailLabel8.textColor = UIColor.lightTextColor()
		detailLabel9.textColor = UIColor.lightTextColor()

		setFontSize(14)
		setConstraints()
	}

	override func setConstraints() {

		contentView.snp_updateConstraints { (make) -> Void in
			make.edges.equalTo(self.snp_edges)
			make.width.equalTo(self.snp_width)
			make.bottom.equalTo(detailLabel9.snp_bottom)
		}

		titleLabel1.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(0)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
		}

		titleLabel2.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(titleLabel1.snp_bottom)
			make.left.equalTo(titleLabel1.snp_left)
			make.right.equalTo(titleLabel1.snp_right)
		}

		// 初始生命 满级生命 满觉生命 初始攻击 满级攻击 满觉攻击
		detailLabel1.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(titleLabel2.snp_bottom).offset(12)
			make.left.equalTo(titleLabel2.snp_left)
			make.width.equalTo(detailLabel2.snp_width)
		}

		// 攻距 攻数 攻速 韧性 移速 成长
		detailLabel2.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel1.snp_top)
			make.left.equalTo(detailLabel1.snp_right)
			make.width.equalTo(detailLabel1.snp_width)
			make.right.equalTo(contentView.snp_right).offset(-8)
		}

		// 初始DPS 满级DPS 满觉DPS 初始总DPS 满级总DPS 满觉总DPS
		detailLabel3.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel1.snp_bottom).offset(8)
			make.left.equalTo(detailLabel1.snp_left)
			make.right.equalTo(detailLabel1.snp_right)
		}

		// 五属性 + 多段攻击
		detailLabel4.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel2.snp_bottom).offset(8)
			make.left.equalTo(detailLabel2.snp_left)
			make.right.equalTo(detailLabel2.snp_right)
		}

		// 国家 性别 年龄
		detailLabel5.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel3.snp_bottom).offset(8)
			make.left.equalTo(detailLabel3.snp_left)
			make.right.equalTo(detailLabel4.snp_right)
		}

		if (getIsPortrait()) {
			// 职业 兴趣 性格
			detailLabel6.snp_updateConstraints { (make) -> Void in
				make.top.equalTo(detailLabel5.snp_bottom).offset(8)
				make.left.equalTo(detailLabel5.snp_left)
				make.right.equalTo(detailLabel5.snp_right)
			}
		}
		else {
			detailLabel6.snp_updateConstraints { (make) -> Void in
				make.top.equalTo(detailLabel4.snp_bottom).offset(8)
				make.left.equalTo(detailLabel4.snp_left)
				make.right.equalTo(detailLabel4.snp_right)
			}
		}
        
		// 获取方式
		detailLabel7.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel6.snp_bottom).offset(8)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
		}

		// 备注
		detailLabel8.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel7.snp_bottom).offset(8)
			make.left.equalTo(detailLabel7.snp_left)
			make.right.equalTo(detailLabel7.snp_right)
		}

		detailLabel9.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel8.snp_bottom).offset(8)
			make.left.equalTo(detailLabel8.snp_left)
			make.right.equalTo(detailLabel8.snp_right)
		}
	}
}
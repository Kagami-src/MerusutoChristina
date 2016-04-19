//
//  MonsterDetailView.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/14.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MonsterPropertyDetailView: PropertyDetailView {

	var titleLabel: UILabel!
	var rareLabel: UILabel!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!
	var detailLabel4: UILabel!
	var detailLabel5: UILabel!
	var detailLabel6: UILabel!
	var detailLabel7: UILabel!
	var detailLabel8: UILabel!

	var contentView: UIView!
	override var item: CharacterItem! {
		didSet {
            let monsterItem = item as! MonsterItem
            
			titleLabel.text = "\(item.name) \(item.rareString)"
			rareLabel.text = "ID：\(item.id)"

			detailLabel1.text = "攻距：\(item.aarea)\n韧性：\(item.tenacity)\n移速：\(item.mspd)\n溅射距离：\(monsterItem.sarea)"
			detailLabel2.text = "攻数：\(item.anum)\n多段：\(item.hits)\n皮肤：\(monsterItem.skin)\n攻速：\(item.aspd)"

			detailLabel3.text = "技能"
			detailLabel4.text = "\(monsterItem.skill)\n技能消耗：\(monsterItem.sklsp)\n技能CD：\(monsterItem.sklcd)"

			detailLabel5.text = "获得方式"
			detailLabel6.text = item.obtain

			detailLabel7.text = item.remark == "" ? "" : "简介"
			detailLabel8.text = item.remark

			setConstraints()
		}
	}

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)


		contentView = UIView()
		self.addSubview(contentView)

		titleLabel = UILabel();
		rareLabel = UILabel()
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();
		detailLabel4 = UILabel();
		detailLabel5 = UILabel();
		detailLabel6 = UILabel();
		detailLabel7 = UILabel();
		detailLabel8 = UILabel();

		contentView.addSubview(titleLabel)
		contentView.addSubview(rareLabel)
		contentView.addSubview(detailLabel1)
		contentView.addSubview(detailLabel2)
		contentView.addSubview(detailLabel3)
		contentView.addSubview(detailLabel4)
		contentView.addSubview(detailLabel5)
		contentView.addSubview(detailLabel6)
		contentView.addSubview(detailLabel7)
		contentView.addSubview(detailLabel8)

		titleLabel.numberOfLines = 0;
		rareLabel.numberOfLines = 0;
		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
		detailLabel4.numberOfLines = 0;
		detailLabel5.numberOfLines = 0;
		detailLabel6.numberOfLines = 0;
		detailLabel7.numberOfLines = 0;
		detailLabel8.numberOfLines = 0;

		titleLabel.textColor = UIColor.lightTextColor()
		rareLabel.textColor = UIColor.lightTextColor()
		detailLabel1.textColor = UIColor.lightTextColor()
		detailLabel2.textColor = UIColor.lightTextColor()
		detailLabel3.textColor = UIColor.lightTextColor()
		detailLabel4.textColor = UIColor.lightTextColor()
		detailLabel5.textColor = UIColor.lightTextColor()
		detailLabel6.textColor = UIColor.lightTextColor()
		detailLabel7.textColor = UIColor.lightTextColor()
		detailLabel8.textColor = UIColor.lightTextColor()

		setFontSize(14)
		setConstraints()
	}

	override func setFontSize(value: CGFloat) {
		let font: UIFont = UIFont.boldSystemFontOfSize(value)

		rareLabel.font = font;
		detailLabel1.font = font;
		detailLabel2.font = font;
		detailLabel4.font = font;
		detailLabel6.font = font;
		detailLabel8.font = font;

		let titleFont = UIFont.systemFontOfSize(value * 1.28)
		titleLabel.font = titleFont
		detailLabel3.font = titleFont
		detailLabel5.font = titleFont
		detailLabel7.font = titleFont
	}

	override func setConstraints() {

		contentView.snp_updateConstraints { (make) -> Void in
			make.edges.equalTo(self.snp_edges)
			make.width.equalTo(self.snp_width)
			make.bottom.equalTo(detailLabel8.snp_bottom)
		}

		titleLabel.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(0)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
		}

		rareLabel.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
			make.left.equalTo(titleLabel.snp_left)
			make.right.equalTo(titleLabel.snp_right)
		}

		detailLabel1.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(rareLabel.snp_bottom).offset(12)
			make.left.equalTo(rareLabel.snp_left)
			make.width.equalTo(detailLabel2.snp_width)
		}

		detailLabel2.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel1.snp_top)
			make.left.equalTo(detailLabel1.snp_right)
			make.width.equalTo(detailLabel1.snp_width)
			make.right.equalTo(contentView.snp_right).offset(-8)
		}

		// 技能
		detailLabel3.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel1.snp_bottom).offset(12)
			make.left.equalTo(detailLabel1.snp_left)
			make.right.equalTo(detailLabel2.snp_right)
		}

		// 技能描述
		detailLabel4.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel3.snp_bottom).offset(4)
			make.left.equalTo(detailLabel3.snp_left)
			make.right.equalTo(detailLabel3.snp_right)
		}

		// 获取方式
		detailLabel5.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel4.snp_bottom).offset(12)
			make.left.equalTo(detailLabel4.snp_left)
			make.right.equalTo(detailLabel4.snp_right)
		}

		// 获取方式详情
		detailLabel6.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel5.snp_bottom).offset(4)
			make.left.equalTo(detailLabel5.snp_left)
			make.right.equalTo(detailLabel5.snp_right)
		}

		// 简介
		detailLabel7.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel6.snp_bottom).offset(12)
			make.left.equalTo(detailLabel6.snp_left)
			make.right.equalTo(detailLabel6.snp_right)
		}

		// 简介详情
		detailLabel8.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(detailLabel7.snp_bottom).offset(4)
			make.left.equalTo(detailLabel7.snp_left)
			make.right.equalTo(detailLabel7.snp_right)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}

//
//  CharacterListCell.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/24.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import SDWebImage

class CharacterListCell: UITableViewCell {

	var rareLabel: UILabel!
	var titleLabel: UILabel!
	var thumbImageView: UIImageView!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!
	var detailLabel4: UILabel!
	var elementView: ElementView!

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.selectionStyle = UITableViewCellSelectionStyle.None

		// print("cell init")

		rareLabel = UILabel()
		titleLabel = UILabel();
		thumbImageView = UIImageView(image: UIImage(named: "thumbnail"))
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();
		detailLabel4 = UILabel();
		elementView = ElementView()

		self.addSubview(rareLabel)
		self.addSubview(titleLabel)
		self.addSubview(thumbImageView)
		self.addSubview(detailLabel1)
		self.addSubview(detailLabel2)
		self.addSubview(detailLabel3)
		self.addSubview(detailLabel4)
		self.addSubview(elementView)

		// rareLabel.backgroundColor = UIColor.redColor()
		// titleLabel.backgroundColor = UIColor.greenColor()
		// thumbImageView.backgroundColor = UIColor.redColor()
		// detailLabel1.backgroundColor = UIColor.redColor()
		// detailLabel2.backgroundColor = UIColor.yellowColor()
		// detailLabel3.backgroundColor = UIColor.blueColor()
		elementView.backgroundColor = UIColor.whiteColor()

		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
		detailLabel4.numberOfLines = 0;

		let font = UIFont.systemFontOfSize(14);
		rareLabel.font = font;
		titleLabel.font = font;
		detailLabel1.font = font;
		detailLabel2.font = font;
		detailLabel3.font = font;
		detailLabel4.font = font;
	}

	var item: CharacterItem! {
		didSet {
			let item = self.item

			rareLabel.text = item.rareString
			titleLabel.text = item.title + item.name
			detailLabel1.text = "生命: \(item.life)\n攻击: \(item.atk)\n攻距: \(item.aarea)\n攻数: \(item.anum)"
			detailLabel2.text = "攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
			detailLabel3.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%"
			detailLabel4.text = "暗: \(Int(item.dark * 100))%\n段数: \(item.hits)\nDPS: \(item.dps)\n总DPS: \(item.mdps)"
			elementView.item = item

			let imageUrl = DataManager.getGithubURL("units/thumbnail/\(item.id).png")
			thumbImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "thumbnail"), options: [SDWebImageOptions.RetryFailed])

			setNeedsLayout()
		}
	}

	override func layoutSubviews() {

		super.layoutSubviews()

		setConstraints()
	}

	func setConstraints() {

		rareLabel.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(self).offset(8)
			make.top.equalTo(self).offset(8)
			make.height.equalTo(21)

			let width = getStringWidth(rareLabel.text!, font: rareLabel.font)
			make.width.equalTo(width)
		}

		titleLabel.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(rareLabel.snp_right).offset(8)
			make.right.equalTo(self.snp_right).offset(-8)
			make.height.equalTo(rareLabel.snp_height)
			make.top.equalTo(rareLabel.snp_top)
		}

		thumbImageView.snp_updateConstraints { (make) -> Void in
			make.width.equalTo(54)
			make.height.equalTo(72)
			make.left.equalTo(self.snp_left).offset(8);
			make.centerY.equalTo(self.detailLabel1.snp_centerY)
		}

		detailLabel1.snp_removeConstraints()
		detailLabel2.snp_removeConstraints()
		detailLabel3.snp_removeConstraints()
		detailLabel4.snp_removeConstraints()

		if (getIsPortrait()) {

			detailLabel1.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(thumbImageView.snp_right).offset(8)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				// make.width.equalTo(100)
				make.width.equalTo(detailLabel2.snp_width)
			}

			detailLabel2.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(detailLabel1.snp_right)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				make.width.equalTo(detailLabel1.snp_width)
				make.right.equalTo(elementView.snp_left).offset(0)
			}

			detailLabel3.snp_updateConstraints(closure: { (make) -> Void in
				make.width.equalTo(0)
				make.height.equalTo(0)
			})

			detailLabel4.snp_updateConstraints(closure: { (make) -> Void in
				make.width.equalTo(0)
				make.height.equalTo(0)
			})

			elementView.snp_updateConstraints(closure: { (make) -> Void in
				make.width.equalTo(80)
				make.height.equalTo(80)
				make.centerY.equalTo(detailLabel2.snp_centerY)
				make.right.equalTo(self.snp_right).offset(-8)
			})
		}
		else {
			detailLabel1.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(thumbImageView.snp_right).offset(8)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				make.width.equalTo(detailLabel2.snp_width)
			}

			detailLabel2.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(detailLabel1.snp_right)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				make.width.equalTo(detailLabel3.snp_width)
			}

			detailLabel3.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(detailLabel2.snp_right)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				make.width.equalTo(detailLabel1.snp_width)
			}

			detailLabel4.snp_updateConstraints(closure: { (make) -> Void in
				make.left.equalTo(detailLabel3.snp_right)
				make.top.equalTo(titleLabel.snp_bottom)
				make.bottom.equalTo(self.snp_bottom)
				make.width.equalTo(detailLabel1.snp_width)
				make.right.equalTo(elementView.snp_left).offset(0)
			})

			elementView.snp_updateConstraints(closure: { (make) -> Void in
				make.width.equalTo(80)
				make.height.equalTo(80)
				make.centerY.equalTo(detailLabel2.snp_centerY)
				make.right.equalTo(self.snp_right).offset(-8)
			})
		}
	}
}


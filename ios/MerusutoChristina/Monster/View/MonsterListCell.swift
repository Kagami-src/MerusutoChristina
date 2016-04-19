//
//  MonsterListCell.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MonsterListCell: UITableViewCell {

	var rareLabel: UILabel!
	var titleLabel: UILabel!
	var thumbImageView: UIImageView!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = UITableViewCellSelectionStyle.None


		rareLabel = UILabel()
        titleLabel = UILabel();
		thumbImageView = UIImageView(image: UIImage(named: "thumbnail"))
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();

		self.addSubview(rareLabel)
		self.addSubview(titleLabel)
		self.addSubview(thumbImageView)
		self.addSubview(detailLabel1)
		self.addSubview(detailLabel2)
		self.addSubview(detailLabel3)

//		rareLabel.backgroundColor = UIColor.redColor()
//		titleLabel.backgroundColor = UIColor.greenColor()
//		thumbImageView.backgroundColor = UIColor.redColor()
//		detailLabel1.backgroundColor = UIColor.redColor()
//		detailLabel2.backgroundColor = UIColor.yellowColor()
//		detailLabel3.backgroundColor = UIColor.blueColor()

		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
        
        let font = UIFont.systemFontOfSize(14);
        rareLabel.font = font;
        titleLabel.font = font;
        detailLabel1.font = font;
        detailLabel2.font = font;
        detailLabel3.font = font;

	}    
    
	var item: MonsterItem! {
		didSet {

			rareLabel.text = item.rareString
			titleLabel.text = item.title + item.name
			detailLabel1.text = "攻距: \(item.aarea)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n溅射距离: \(item.sareaString)"
			detailLabel2.text = "攻数: \(item.anum)\n多段: \(item.hits)\n皮肤: \(item.skinString)\n攻速: \(item.aspdString)"
			detailLabel3.text = "极限值: \(item.sklmax)%\n技能: \(item.skillType)\n技能CD: \(item.sklcd)\n技能SP: \(item.sklsp)"

			let imageUrl = DataManager.getGithubURL("monsters/thumbnail/\(item.id).png")
			thumbImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "thumbnail"), options: SDWebImageOptions.RetryFailed)

			setConstraints()
		}
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
			make.width.equalTo(detailLabel3.snp_width)
		}

		detailLabel3.snp_updateConstraints { (make) -> Void in
			make.left.equalTo(detailLabel2.snp_right)
			make.top.equalTo(titleLabel.snp_bottom)
			make.bottom.equalTo(self.snp_bottom)
			make.width.equalTo(detailLabel1.snp_width)
			make.right.equalTo(self.snp_right).offset(-8)
		}
	}
}

//
//  MonsterDetailController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/12.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MonsterDetailController: CharacterDetailController {

	override func getPropertyDetailView() -> PropertyDetailView {
		return MonsterPropertyDetailView(frame: self.view.bounds)
	}
    
    override func getItemUrl() -> NSURL {
        return DataManager.getGithubURL("monsters/original/\(item.id).png")
    }

//	override func setConstraints() {
//		scrollView.snp_updateConstraints { (make) -> Void in
//			make.left.equalTo(self.view)
//			make.right.equalTo(self.view)
//			make.top.equalTo(self.view)
//			make.bottom.equalTo(self.view)
//		}
//
//		contentView.snp_updateConstraints { (make) -> Void in
//			make.edges.equalTo(scrollView)
//			make.height.equalTo(scrollView)
//			make.width.equalTo(scrollView).multipliedBy(2)
//		}
//
//		imageViewer.snp_updateConstraints { (make) -> Void in
//			make.left.equalTo(contentView.snp_left)
//			make.top.equalTo(contentView.snp_top)
//			make.bottom.equalTo(contentView.snp_bottom)
//			make.width.equalTo(contentView).multipliedBy(0.5)
//		}
//
//		propertyViewer.snp_updateConstraints { (make) -> Void in
//			make.left.equalTo(imageViewer.snp_right)
//			make.top.equalTo(imageViewer.snp_top).offset(20)
//			make.bottom.equalTo(imageViewer.snp_bottom).offset(-20)
//			make.width.equalTo(imageViewer.snp_width)
//		}
//
//		pageController.snp_makeConstraints { [unowned self](make) -> Void in
//			make.centerX.equalTo(self.view.snp_centerX)
//			make.bottom.equalTo(self.view.snp_bottom).offset(0)
//			make.width.equalTo(80)
//			make.height.equalTo(20)
//		}
//	}
}

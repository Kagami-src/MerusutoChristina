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
    
    @IBOutlet var rareLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var detailLabel1: UILabel!
    @IBOutlet var detailLabel2: UILabel!
    @IBOutlet var detailLabel3: UILabel!
    @IBOutlet var detailLabel4: UILabel!
    @IBOutlet var elementView: ElementView!
    
    var item: CharacterItem! {
        didSet {
            let item = self.item
            
            rareLabel.text = item.rareString
            titleLabel.text = item.title + item.name
            detailLabel1.text = "生命: \(item.life)\n攻击: \(item.atk)\n攻距: \(item.aarea)\n攻数: \(item.anum)"
            detailLabel2.text = "攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
            detailLabel3.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%"
            detailLabel4.text = "暗: \(Int(item.dark * 100))%\n\nDPS: \(item.dps)\n总DPS: \(item.mdps)"
            elementView.item = item
            
            let imageUrl = DataManager.getGithubURL("units/thumbnail/\(item.id).png")
            print("load image with url \(imageUrl)")
            thumbImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "thumbnail"), options: SDWebImageOptions.RetryFailed)
        }
    }
}

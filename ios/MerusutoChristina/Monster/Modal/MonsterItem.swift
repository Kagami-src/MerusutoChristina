//
//  MonsterItem.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/8.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import Foundation
import SwiftyJSON
	
class MonsterItem :CharacterItem{

	var name_jp: String // 日服名称

	var skin: Int // 皮肤 1坚硬 2常规 3柔软
	var sklsp: Int // 技能消耗SP
	var sklcd: Int // 技能CD
	var skill: String // 技能描述
	var parts: Int // 多部位
	var sarea: Int // 溅射范围
    var sklmax: Float //极限值


	override init(data: JSON) {

		name_jp = data["name_jp"].stringValue // 日服名称
        
		skin = data["skin"].intValue // 皮肤 1坚硬 2常规 3柔软
		sklsp = data["sklsp"].intValue // 技能消耗SP
		sklcd = data["sklcd"].intValue // 技能CD
		skill = data["skill"].stringValue // 技能描述
		parts = data["parts"].intValue  //多部位
		sarea = data["sarea"].intValue  //溅射范围
        sklmax = data["sklmax"].floatValue  //极限值

         super.init(data: data)
	}
    
    
    var skinString: String {
        get {
            return safeGetString(["坚硬", "常规", "柔软"], index: skin)
        }
    }
    
    var skillShortString: String {
        get {
            return skill.componentsSeparatedByString(": ").first!
        }
    }
    
    var skillType:String{
        get {            
            return skill.componentsSeparatedByString("：")[0]
        }
    }
    
    var sareaString:String{
        get{
              return sarea == 0 ? "暂缺" : String(sarea)
        }
    }
}
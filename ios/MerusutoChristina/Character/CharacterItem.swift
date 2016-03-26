//
//  UnitItem.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//
import SwiftyJSON
import Foundation

func getStringValue(data: JSON, key: String) -> String {
	let value = data[key].stringValue as String
	return value.characters.count == 0 ? "暂缺" : value
}

class CharacterItem {
	var name: String // 名称
	var id: Int
	var rare: Int // 稀有度
	var element: Int // 属性 1火 2水 3风 4光 5暗

	var fire: Float // 火
	var aqua: Float // 水
	var wind: Float // 风
	var light: Float // 光
	var dark: Float // 暗

	// =====
	// 同伴
	var title: String // 称号
	var atk: Int // 攻击
	var life: Int // 生命
	var mspd: Int // 移动速度
	var tenacity: Int // 韧性
	var aspd: Float // 攻击速度
	var country: String // 国家

	var weapon: Int // 武器 1斩击 2突击 3打击 4弓箭 5魔法 6铳弹 7回复
	var aarea: Int // 攻击范围
	var anum: Int // 攻击数量
	var type: Int // 类型 1早熟 2平均 3晚成

	var gender: Int // 性别 1不明 2男 3女
	var age: Int // 年龄
	var career: String // 职业
	var interest: String // 兴趣
	var nature: String // 性格
	// =====

	// =====
	// 魔宠
	var skin: Int // 皮肤 1坚硬 2常规 3柔软
	var sklsp: Int // 技能消耗SP
	var sklcd: Int // 技能CD
	var skill: String // 技能描述
	// =====

	var obtain: String // 获取方式
	var remark: String // 备注
	var contributors: [JSON]? // 数据提供者
    var server: Int //新品上架 1日服 2国服
    var exchange: Int //交换所 1历代交换所人物 2历代活动人物 3其他
    

	var originalAtk, originalLife: Int
	var dps: Int = 0
	var mdps: Int = 0

	init(data: JSON) {
		name = data["name"].stringValue // 名称
		id = data["id"].intValue
		rare = data["rare"].intValue // 稀有度
		element = data["element"].intValue // 属性 1火 2水 3风 4光 5暗

		fire = data["fire"].floatValue // 火
		aqua = data["aqua"].floatValue // 水
		wind = data["wind"].floatValue // 风
		light = data["light"].floatValue // 光
		dark = data["dark"].floatValue // 暗

		// =====
		// 同伴
		title = data["title"].stringValue // 称号
		atk = data["atk"].intValue // 攻击
		life = data["life"].intValue // 生命
		mspd = data["mspd"].intValue // 移动速度
		tenacity = data["tenacity"].intValue // 韧性
		aspd = data["aspd"].floatValue // 攻击速度
		country = data["country"].stringValue // 国家

		weapon = data["weapon"].intValue // 武器 1斩击 2突击 3打击 4弓箭 5魔法 6铳弹 7回复
		aarea = data["aarea"].intValue // 攻击范围
		anum = data["anum"].intValue // 攻击数量
		type = data["type"].intValue // 类型 1早熟 2平均 3晚成

		country = getStringValue(data, key: "country")
		gender = data["gender"].intValue
		age = data["age"].intValue
		career = getStringValue(data, key: "career")
		interest = getStringValue(data, key: "interest")
		nature = getStringValue(data, key: "nature")
		// =====

		// =====
		// 魔宠
		skin = data["skin"].intValue // 皮肤 1坚硬 2常规 3柔软
		sklsp = data["sklsp"].intValue // 技能消耗SP
		sklcd = data["sklcd"].intValue // 技能CD
		skill = data["skill"].stringValue // 技能描述
		// =====

		obtain = data["obtain"].stringValue // 获取方式
		remark = data["remark"].stringValue // 备注
		contributors = data["contributors"].array // 数据提供者
        server = data["server"].intValue  //新品上架 1日服 2国服
        exchange = data["exchange"].intValue == 0 ? 3 : data["exchange"].intValue  //交换所 1历代交换所人物 2历代活动人物 3其他

		levelMode = 0
		originalAtk = atk
		originalLife = life
		dps = calcDPS(atk)
		mdps = calcMDPS(atk)
	}

	var contributorsString: String {
		get {
			if let collection = contributors {
				var array: [String] = []
				for item in collection {
					array.append(item.stringValue)
				}
                
//				return "、".join(array)
                return array.joinWithSeparator("、")
            
			} else {
				return ""
			}
		}
	}

	var rareString: String {
		get {
			return 0 < rare && rare < 6 ? String(count: rare, repeatedValue: Character("★")) : "暂缺"
		}
	}

	var ageString: String {
		get {
			return age > 0 ? "\(age)岁" : "暂缺"
		}
	}

	func safeGetString(array: [String], index: Int) -> String {
		return (0 < index && index < array.count + 1) ? array[index - 1] : "暂缺"
	}

	var elementString: String {
		get {
			return safeGetString(["火", "水", "风", "光", "暗"], index: element)
		}
	}

	var typeString: String {
		get {
			return safeGetString(["早熟", "平均", "晚成"], index: type)
		}
	}

	var skinString: String {
		get {
			return safeGetString(["坚硬", "常规", "柔软"], index: skin)
		}
	}

	var genderString: String {
		get {
			return safeGetString(["不明", "男", "女"], index: gender)
		}
	}

	var skillShortString: String {
		get {
			return skill.componentsSeparatedByString(": ").first!
		}
	}

	var levelMode: Int {
		didSet {
			atk = calc(originalAtk)
			life = calc(originalLife)
			dps = calcDPS(atk)
			mdps = calcMDPS(atk)
		}
	}

	func calcDPS(atk: Int) -> Int {
		if aspd == 0 {
			return 0
		} else {
			return Int(Float(atk) / Float(aspd))
		}
	}

	func calcMDPS(atk: Int) -> Int {
		if aspd == 0 {
			return 0
		} else {
			return Int(Float(atk) / Float(aspd) * Float(anum))
		}
	}

	func calc(value: Int) -> Int {
		switch levelMode {
		case 0:
			return value
		case 1:
			return calcMaxLv(value)
		case 2:
			return calcMaxLvAndGrow(value)
		default:
			return 0
		}
	}

	func calcF() -> Float {
		return 1.8 + 0.1 * Float(type)
	}

	// 零觉满级
	func calcMaxLv(value: Int) -> Int {
		return Int(Float(value) * calcF())
	}

	// 满觉满级
	func calcMaxLvAndGrow(value: Int) -> Int {
		let f = calcF()
		let lhs = Int(Float(value) * calcF())
		var rhs = Int(Float(value) * (f - 1) / (19 + 10 * Float(rare)))
		rhs *= 5 * (rare == 1 ? 5 : 15)
		return lhs + rhs
	}
}
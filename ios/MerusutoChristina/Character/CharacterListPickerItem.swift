//
//  CharacterListPickerItem.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/3/1.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

class CharacterListPickerItem {
	var value: Int = 0
	var originalValue: Int = 0

	var min: Int?
	var max: Int?
	var range: Bool = false

	var depth: Int = 1
	var title: String
	var children = [CharacterListPickerItem]()

	var resetable: Bool

	init(title: String) {
		self.title = title
		self.resetable = false
	}

	convenience init(title: String, min: Int?, max: Int?) {
		self.init(title: title)
		self.min = min
		self.max = max
		self.range = true
	}

	convenience init(title: String, children: [CharacterListPickerItem]) {
		self.init(title: title)
		self.children = children
		self.resetable = true
	}

	convenience init(title: String, depth: Int, children: [CharacterListPickerItem]) {
		self.init(title: title, children: children)
		self.depth = depth
		self.resetable = false
	}

	func child(index: Int) -> CharacterListPickerItem {
		if index < children.count {
			return children[index]
		} else {
			return unknownPicker
		}
	}

	func check(value: Int) -> Bool {
		if (self.value == 0 || self.value == value) {
			return false // return false代表符合条件
		}
		let current = child(self.value)
		if (current.range) {
			if let min = current.min {
				if min > value {
					return true
				}
			}
			if let max = current.max {
				if max < value {
					return true
				}
			}
			return false
		}
		return true
	}

	func checkString(value: String) -> Bool {
		if (self.value == 0 || child(self.value).title == value) {
			return false
		}
		return true
	}

	func reset() {
		if resetable {
			value = 0
		} else {
			for child in children {
				child.reset()
			}
		}
	}
}

let unknownPicker = CharacterListPickerItem(title: "未知")

let levelPicker = CharacterListPickerItem(title: "等级", children: [
	CharacterListPickerItem(title: "零觉零级"),
	CharacterListPickerItem(title: "零觉满级"),
	CharacterListPickerItem(title: "满觉满级")
])

let sortPicker = CharacterListPickerItem(title: "排序", children: [
	CharacterListPickerItem(title: "稀有度"),
	CharacterListPickerItem(title: "单体DPS"),
	CharacterListPickerItem(title: "多体DPS"),
	CharacterListPickerItem(title: "生命力"),
	CharacterListPickerItem(title: "攻击"),
	CharacterListPickerItem(title: "攻击距离"),
	CharacterListPickerItem(title: "攻击数量"),
	CharacterListPickerItem(title: "攻击速度"),
	CharacterListPickerItem(title: "韧性"),
	CharacterListPickerItem(title: "移动速度"),
	CharacterListPickerItem(title: "新品上架")
])

let rarePicker = CharacterListPickerItem(title: "稀有度", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "★"),
	CharacterListPickerItem(title: "★★"),
	CharacterListPickerItem(title: "★★★"),
	CharacterListPickerItem(title: "★★★★"),
	CharacterListPickerItem(title: "★★★★★"),
	CharacterListPickerItem(title: "★★★以上", min: 3, max: 5),
	CharacterListPickerItem(title: "★★★★以上", min: 4, max: 5)
])

let elementPicker = CharacterListPickerItem(title: "元素", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "火"),
	CharacterListPickerItem(title: "水"),
	CharacterListPickerItem(title: "风"),
	CharacterListPickerItem(title: "光"),
	CharacterListPickerItem(title: "暗"),
	CharacterListPickerItem(title: "火/水/风", min: 1, max: 3),
	CharacterListPickerItem(title: "光/暗", min: 4, max: 5)
])

let weaponPicker = CharacterListPickerItem(title: "武器", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "斩击"),
	CharacterListPickerItem(title: "突击"),
	CharacterListPickerItem(title: "打击"),
	CharacterListPickerItem(title: "弓箭"),
	CharacterListPickerItem(title: "魔法"),
	CharacterListPickerItem(title: "铳弹"),
	CharacterListPickerItem(title: "回复"),
	CharacterListPickerItem(title: "斩/突/打", min: 1, max: 3),
	CharacterListPickerItem(title: "弓/魔/铳", min: 4, max: 6)
])

let typePicker = CharacterListPickerItem(title: "成长", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "早熟"),
	CharacterListPickerItem(title: "平均"),
	CharacterListPickerItem(title: "晚成")
])

let aareaPicker = CharacterListPickerItem(title: "攻击距离", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "近程", min: 1, max: 50),
	CharacterListPickerItem(title: "中程", min: 51, max: 150),
	CharacterListPickerItem(title: "远程", min: 151, max: 500)
])

let anumPicker = CharacterListPickerItem(title: "攻击数量", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "1体"),
	CharacterListPickerItem(title: "2体"),
	CharacterListPickerItem(title: "3体"),
	CharacterListPickerItem(title: "4体"),
	CharacterListPickerItem(title: "5体"),
	CharacterListPickerItem(title: "2/3体", min: 2, max: 3),
	CharacterListPickerItem(title: "4/5体", min: 4, max: 5)
])

let genderPicker = CharacterListPickerItem(title: "性别", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "不明"),
	CharacterListPickerItem(title: "男"),
	CharacterListPickerItem(title: "女")
])

let serverPicker = CharacterListPickerItem(title: "新品上架", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "日服"),
	CharacterListPickerItem(title: "国服"),
])

let exchangePicker = CharacterListPickerItem(title: "交换所", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "历代交换所人物"),
	CharacterListPickerItem(title: "历代活动人物"),
	CharacterListPickerItem(title: "其他")
])

let countryPicker = CharacterListPickerItem(title: "国别", children: [
	CharacterListPickerItem(title: "全部"),
	CharacterListPickerItem(title: "沙漠之国"),
	CharacterListPickerItem(title: "电之国"),
	CharacterListPickerItem(title: "科学之国"),
	CharacterListPickerItem(title: "空之国"),
	CharacterListPickerItem(title: "常夏之国"),
	CharacterListPickerItem(title: "魔法之国"),
	CharacterListPickerItem(title: "妖精之国"),
	CharacterListPickerItem(title: "王国"),
	CharacterListPickerItem(title: "死者の国"),
	CharacterListPickerItem(title: "和之国"),
	CharacterListPickerItem(title: "动物之国"),
	CharacterListPickerItem(title: "机械之国"),
	CharacterListPickerItem(title: "异邦"),
	CharacterListPickerItem(title: "雪之国"),
	CharacterListPickerItem(title: "植物之国"),
	CharacterListPickerItem(title: "西部之国"),
	CharacterListPickerItem(title: "点心之国"),
	CharacterListPickerItem(title: "恐龙之国"),
	CharacterListPickerItem(title: "死者之国"),
	CharacterListPickerItem(title: "崩坏之国"),
	CharacterListPickerItem(title: "华夏之国"),
	CharacterListPickerItem(title: "ドラポの国"),
	CharacterListPickerItem(title: "アスタリアの世界"),
	CharacterListPickerItem(title: "お菓子の国"),
	CharacterListPickerItem(title: "科学の国"),
	CharacterListPickerItem(title: "弹幕之国"),
	CharacterListPickerItem(title: "漫画之国"),
	CharacterListPickerItem(title: "魔女之国"),
	CharacterListPickerItem(title: "喵之国"),
	CharacterListPickerItem(title: "女生重奏曲之国"),
	CharacterListPickerItem(title: "千メモの国"),
	CharacterListPickerItem(title: "聖剣伝説の国"),
	CharacterListPickerItem(title: "サモンズの国"),
	CharacterListPickerItem(title: "常夏の国"),
	CharacterListPickerItem(title: "暂缺")
])

let filterPicker = CharacterListPickerItem(title: "筛选", depth: 2, children: [
	rarePicker, elementPicker, weaponPicker, typePicker, aareaPicker, anumPicker, genderPicker, serverPicker, exchangePicker, countryPicker
])

let rootPicker = CharacterListPickerItem(title: "", children: [
	levelPicker, sortPicker, filterPicker
])

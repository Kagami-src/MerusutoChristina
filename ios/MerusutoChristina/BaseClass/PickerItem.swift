//
//  PickerItem.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/3/1.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

class PickerItem {
	var value: Int = 0
	var originalValue: Int = 0

	var min: Int?
	var max: Int?
	var range: Bool = false

	var depth: Int = 1
	var title: String
	var children = [PickerItem]()

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

	convenience init(title: String, children: [PickerItem]) {
		self.init(title: title)
		self.children = children
		self.resetable = true
	}

	convenience init(title: String, depth: Int, children: [PickerItem]) {
		self.init(title: title, children: children)
		self.depth = depth
		self.resetable = false
	}

	func child(index: Int) -> PickerItem {
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

let unknownPicker = PickerItem(title: "未知")

//MARK:PickerItem for Character
let levelPicker = PickerItem(title: "等级", children: [
	PickerItem(title: "零觉零级"),
	PickerItem(title: "零觉满级"),
	PickerItem(title: "满觉满级")
])

let sortPicker = PickerItem(title: "排序", children: [
	PickerItem(title: "稀有度"),
	PickerItem(title: "单体DPS"),
	PickerItem(title: "多体DPS"),
	PickerItem(title: "生命力"),
	PickerItem(title: "攻击"),
	PickerItem(title: "攻击距离"),
	PickerItem(title: "攻击数量"),
	PickerItem(title: "攻击速度"),
	PickerItem(title: "韧性"),
	PickerItem(title: "移动速度"),
	PickerItem(title: "新品上架"),
	PickerItem(title: "多段攻击"),
])

let rarePicker = PickerItem(title: "稀有度", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "★"),
	PickerItem(title: "★★"),
	PickerItem(title: "★★★"),
	PickerItem(title: "★★★★"),
	PickerItem(title: "★★★★★"),
	PickerItem(title: "★★★以上", min: 3, max: 5),
	PickerItem(title: "★★★★以上", min: 4, max: 5)
])

let elementPicker = PickerItem(title: "元素", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "火"),
	PickerItem(title: "水"),
	PickerItem(title: "风"),
	PickerItem(title: "光"),
	PickerItem(title: "暗"),
	PickerItem(title: "火/水/风", min: 1, max: 3),
	PickerItem(title: "光/暗", min: 4, max: 5)
])

let weaponPicker = PickerItem(title: "武器", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "斩击"),
	PickerItem(title: "突击"),
	PickerItem(title: "打击"),
	PickerItem(title: "弓箭"),
	PickerItem(title: "魔法"),
	PickerItem(title: "铳弹"),
	PickerItem(title: "回复"),
	PickerItem(title: "斩/突/打", min: 1, max: 3),
	PickerItem(title: "弓/魔/铳", min: 4, max: 6)
])

let typePicker = PickerItem(title: "成长", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "早熟"),
	PickerItem(title: "平均"),
	PickerItem(title: "晚成")
])

let aareaPicker = PickerItem(title: "攻击距离", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "近程", min: 1, max: 50),
	PickerItem(title: "中程", min: 51, max: 150),
	PickerItem(title: "远程", min: 151, max: 500)
])

let anumPicker = PickerItem(title: "攻击数量", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "1体"),
	PickerItem(title: "2体"),
	PickerItem(title: "3体"),
	PickerItem(title: "4体"),
	PickerItem(title: "5体"),
	PickerItem(title: "2/3体", min: 2, max: 3),
	PickerItem(title: "4/5体", min: 4, max: 5)
])

let genderPicker = PickerItem(title: "性别", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "不明"),
	PickerItem(title: "男"),
	PickerItem(title: "女")
])

let serverPicker = PickerItem(title: "新品上架", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "日服"),
	PickerItem(title: "国服"),
])

let exchangePicker = PickerItem(title: "交换所", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "历代交换所人物"),
	PickerItem(title: "历代活动人物"),
	PickerItem(title: "其他")
])

let countryPicker = PickerItem(title: "国别", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "沙漠之国"),
	PickerItem(title: "电之国"),
	PickerItem(title: "科学之国"),
	PickerItem(title: "空之国"),
	PickerItem(title: "常夏之国"),
	PickerItem(title: "魔法之国"),
	PickerItem(title: "妖精之国"),
	PickerItem(title: "王国"),
	PickerItem(title: "死者の国"),
	PickerItem(title: "和之国"),
	PickerItem(title: "动物之国"),
	PickerItem(title: "机械之国"),
	PickerItem(title: "异邦"),
	PickerItem(title: "雪之国"),
	PickerItem(title: "植物之国"),
	PickerItem(title: "西部之国"),
	PickerItem(title: "点心之国"),
	PickerItem(title: "恐龙之国"),
	PickerItem(title: "死者之国"),
	PickerItem(title: "崩坏之国"),
	PickerItem(title: "华夏之国"),
	PickerItem(title: "ドラポの国"),
	PickerItem(title: "アスタリアの世界"),
	PickerItem(title: "お菓子の国"),
	PickerItem(title: "科学の国"),
	PickerItem(title: "弹幕之国"),
	PickerItem(title: "漫画之国"),
	PickerItem(title: "魔女之国"),
	PickerItem(title: "喵之国"),
	PickerItem(title: "女生重奏曲之国"),
	PickerItem(title: "千メモの国"),
	PickerItem(title: "聖剣伝説の国"),
	PickerItem(title: "サモンズの国"),
	PickerItem(title: "常夏の国"),
	PickerItem(title: "暂缺")
])

let filterPicker = PickerItem(title: "筛选", depth: 2, children: [
	rarePicker, elementPicker, weaponPicker, typePicker, aareaPicker, anumPicker, genderPicker, serverPicker, exchangePicker, countryPicker
])

let rootPicker = PickerItem(title: "", children: [
	levelPicker, sortPicker, filterPicker
])

//MARK:PickerItem for Monster
let monster_sortPicker = PickerItem(title: "排序", children: [
    PickerItem(title: "稀有度"),
    PickerItem(title: "极限值"),
    PickerItem(title: "攻击距离"),
    PickerItem(title: "攻击数量"),
    PickerItem(title: "攻击速度"),
    PickerItem(title: "韧性"),
    PickerItem(title: "移动速度"),
    PickerItem(title: "多段攻击")
])

let monster_filterPicker = PickerItem(title: "筛选", depth: 2, children: [
	monster_rarePicker, elementPicker, monster_skinPicker, monster_skillPicker, aareaPicker, serverPicker
])

let monster_rarePicker = PickerItem(title: "稀有度", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "★"),
	PickerItem(title: "★★"),
	PickerItem(title: "★★★"),
	PickerItem(title: "★★★★"),
	PickerItem(title: "★★★以上", min: 3, max: 5),
])

let monster_skinPicker = PickerItem(title: "皮肤", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "坚硬"),
	PickerItem(title: "常规"),
	PickerItem(title: "柔软"),
	PickerItem(title: "极软"),
	PickerItem(title: "极硬"),
])

let monster_skillPicker = PickerItem(title: "技能", children: [
	PickerItem(title: "全部"),
	PickerItem(title: "治愈"),
	PickerItem(title: "威慑"),
	PickerItem(title: "士气UP"),
	PickerItem(title: "属性魂"),
	PickerItem(title: "幸运UP"),
	PickerItem(title: "麻痹"),
	PickerItem(title: "武器魂"),
	PickerItem(title: "双色破"),
	PickerItem(title: "破系"),
	PickerItem(title: "双色魂"),
	PickerItem(title: "属性弱化"),
	PickerItem(title: "属性强化"),
	PickerItem(title: "国别魂"),
	PickerItem(title: "暂缺"),
	PickerItem(title: "无"),
	PickerItem(title: "其他"),
])

let monster_rootPicker = PickerItem(title: "", children: [
    monster_sortPicker, monster_filterPicker
])


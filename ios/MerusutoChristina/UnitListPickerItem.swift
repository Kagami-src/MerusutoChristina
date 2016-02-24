//
//  UnitListPickerItem.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/3/1.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

class UnitListPickerItem {
	var value: Int = 0
	var originalValue: Int = 0

	var min: Int?
	var max: Int?
	var range: Bool = false

	var depth: Int = 1
	var title: String
	var children = [UnitListPickerItem]()

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

	convenience init(title: String, children: [UnitListPickerItem]) {
		self.init(title: title)
		self.children = children
		self.resetable = true
	}

	convenience init(title: String, depth: Int, children: [UnitListPickerItem]) {
		self.init(title: title, children: children)
		self.depth = depth
		self.resetable = false
	}

	func child(index: Int) -> UnitListPickerItem {
		if index < children.count {
			return children[index]
		} else {
			return unknownPicker
		}
	}

	func check(value: Int) -> Bool {
		if self.value == 0 || self.value == value {
			return false
		}
		let current = child(self.value)
		if current.range {
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

let unknownPicker = UnitListPickerItem(title: "未知")

let levelPicker = UnitListPickerItem(title: "等级", children: [
	UnitListPickerItem(title: "零觉零级"),
	UnitListPickerItem(title: "零觉满级"),
	UnitListPickerItem(title: "满觉满级")
])

let sortPicker = UnitListPickerItem(title: "排序", children: [
	UnitListPickerItem(title: "稀有度"),
	UnitListPickerItem(title: "单体DPS"),
	UnitListPickerItem(title: "多体DPS"),
	UnitListPickerItem(title: "生命力"),
	UnitListPickerItem(title: "攻击"),
	UnitListPickerItem(title: "攻击距离"),
	UnitListPickerItem(title: "攻击数量"),
	UnitListPickerItem(title: "攻击速度"),
	UnitListPickerItem(title: "韧性"),
	UnitListPickerItem(title: "移动速度"),
	UnitListPickerItem(title: "新品上架")
])

let rarePicker = UnitListPickerItem(title: "稀有度", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "★"),
	UnitListPickerItem(title: "★★"),
	UnitListPickerItem(title: "★★★"),
	UnitListPickerItem(title: "★★★★"),
	UnitListPickerItem(title: "★★★★★"),
	UnitListPickerItem(title: "★★★以上", min: 3, max: 5),
	UnitListPickerItem(title: "★★★★以上", min: 4, max: 5)
])

let elementPicker = UnitListPickerItem(title: "元素", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "火"),
	UnitListPickerItem(title: "水"),
	UnitListPickerItem(title: "风"),
	UnitListPickerItem(title: "光"),
	UnitListPickerItem(title: "暗"),
	UnitListPickerItem(title: "火/水/风", min: 1, max: 3),
	UnitListPickerItem(title: "光/暗", min: 4, max: 5)
])

let weaponPicker = UnitListPickerItem(title: "武器", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "斩击"),
	UnitListPickerItem(title: "突击"),
	UnitListPickerItem(title: "打击"),
	UnitListPickerItem(title: "弓箭"),
	UnitListPickerItem(title: "魔法"),
	UnitListPickerItem(title: "铳弹"),
	UnitListPickerItem(title: "回复"),
	UnitListPickerItem(title: "斩/突/打", min: 1, max: 3),
	UnitListPickerItem(title: "弓/魔/铳", min: 4, max: 6)
])

let typePicker = UnitListPickerItem(title: "成长", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "早熟"),
	UnitListPickerItem(title: "平均"),
	UnitListPickerItem(title: "晚成")
])

let aareaPicker = UnitListPickerItem(title: "攻击距离", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "近程", min: 1, max: 50),
	UnitListPickerItem(title: "中程", min: 51, max: 150),
	UnitListPickerItem(title: "远程", min: 151, max: 500)
])

let anumPicker = UnitListPickerItem(title: "攻击数量", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "1体"),
	UnitListPickerItem(title: "2体"),
	UnitListPickerItem(title: "3体"),
	UnitListPickerItem(title: "4体"),
	UnitListPickerItem(title: "5体"),
	UnitListPickerItem(title: "2/3体", min: 2, max: 3),
	UnitListPickerItem(title: "4/5体", min: 4, max: 5)
])

let genderPicker = UnitListPickerItem(title: "性别", children: [
	UnitListPickerItem(title: "全部"),
	UnitListPickerItem(title: "不明"),
	UnitListPickerItem(title: "男"),
	UnitListPickerItem(title: "女")
])

let countryPicker = UnitListPickerItem(title: "国别", children: [
	UnitListPickerItem(title: "全部")
])

let filterPicker = UnitListPickerItem(title: "筛选", depth: 2, children: [
	rarePicker, elementPicker, weaponPicker, typePicker, aareaPicker, anumPicker, genderPicker
])

let rootPicker = UnitListPickerItem(title: "", children: [
	levelPicker, sortPicker, filterPicker
])


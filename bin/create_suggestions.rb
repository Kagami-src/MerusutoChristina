require 'leancloud-ruby-client'
require_relative 'color'

AV.init application_id: "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
        api_key: "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg",
        quiet: true

DIFF = <<-EOS
22 [红披巾女忍] 彩叶: hits  -> 2
29 [无影脚格斗家] 提坦: hits  -> 3
33 [绷带格斗家] 法穆: hits  -> 3
53 [流浪的格斗家] 式: hits  -> 3
54 [感电少女] 真央: hits  -> 3
58 [缝纫高手] 弗桐: hits 2 -> 3
63 [面具格斗家] 洛特: hits  -> 3
157 [睿智的探求者] 阿尔西恩: hits  -> 3
161 [狐面倾奇者] 默克莱恩: hits  -> 7
238 [浅红拳法师] 真央: hits  -> 3
267 [炎珠咒术师] 艾凡: hits  -> 2
275 [琉璃僧兵] 紫暮: hits  -> 4
280 [飞翔兔子] 卡洛儿: hits  -> 3
285 [流浪的追求者] 式: hits  -> 4
292 [熏香水使者] 娜修姆: hits  -> 3
293 [天才差生] 尤尔艾: hits 3 -> 4
306 [风召枪的淑女] 弗桐: hits  -> 4
396 [裂风飞燕] 松风: hits  -> 5
422 [焰色拳斗士] 幽武: hits  -> 4
428 [高楼观察者] 斯瓦罗格: hits  -> 2
430 [浅紫的格斗家] 霍西法: hits  -> 3
448 [雪之结晶魔女] 枇枇: hits  -> 3
460 ❤[琉璃僧兵] 紫暮: hits  -> 4
461 ❤[红披巾女忍] 彩叶: hits  -> 2
465 [泡沫之残梦] 埃雷欧诺璐: hits  -> 5
485 [护甲拳师] 艾莉莉: hits  -> 3
492 [水碎的千金] 米露露莉: hits 2 -> 4
505 [机甲格斗家] 迪安: hits  -> 3
512 [创装糖果匠] 伽托: hits  -> 4
517 [博文秘书官] 弗莉妲: hits  -> 4
522 [水神侍奉者] 琳姬: hits  -> 4
523 [星屑道化师] 格伊姆: hits  -> 2
525 [瞬影红忍] 刹那: hits  -> 2
529 [隐貌格斗家] 洛特: hits  -> 3
533 [欢快的紫晶] 法妮: hits  -> 4
543 [鸟笼歌唱者] 缪杰: hits  -> 4
553 [疾风拳士] 提坦: hits  -> 3
569 [三叶忍者] 白爪: hits  -> 2
570 [单恋枪手] 赛尼西奥: anum 2 -> 1
573 [利腿操控家] 里昂赫奥: hits  -> 2
584 [讶然咒学者] 涅兹: anum 1 -> 1
588 [白露绅士] 怀特密鲁: hits 5 -> 6
592 [矿山守护者] 托里斯: hits  -> 5
602 [白闪格斗家] 法穆: hits  -> 3
605 [樱燃舞巫女] 纪久美小町: hits  -> 8
628 [春を統べる者] フロイレイダ: hits  -> 5
639 [緑晶の調石師] エマ: type 1 -> 3
642 [孤高の烈刃] クレア: anum 2 -> 2
656 ❤[孤高の烈刃] クレア: anum 2 -> 2
EOS

def format value
  if value =~ /^\d+\.\d+$/
    value.to_f
  elsif value =~ /^\d+$/
    value.to_i
  else
    nil
  end
end

DIFF.each_line do |line|
  if line =~ /(\d+) ([^:]+): (\S+) ([\.\d]*) -> ([\.\d]+)/
    suggestion = AV::Object.new("Suggestion")
    suggestion["model"] = {klass: "Unit", id: $1.to_i, name: $2}
    suggestion["data"] = [{name: $3, from: format($4), to: format($5)}]
    suggestion.save
  else
    puts line.red
  end
end

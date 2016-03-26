<<<<<<< HEAD
梅露可图鉴
===
查看人物和魔宠属性的APP

Installation
---
项目开发环境没有做Windows兼容，建议不要使用Windows环境开发  
Windows下可以尝试使用Vagrant和Virtual Box，搭建一个Linux开发环境  
Vagrant文档：https://docs.vagrantup.com/v2/

进入Linux或Mac命令行后
```shell
# 进入项目目录
cd path/to/project

# 安装 git
sudo apt-get install git

# 安装 ruby, https://www.brightbox.com/docs/ruby/ubuntu/
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.2

# 安装 Ruby 依赖库
sudo gem install bundler
bundle install
```

Usage
---
```shell
# 爬取日服资源
# 类型：unit 或 monster
# 起始ID、结束ID：资源的起止ID
# 例如：ruby bin/image_spider.rb unit 0 800
ruby bin/image_spider.rb [类型] [起始ID] [结束ID]

# 爬取国服资源
# 抓取的方式和日服不同，不需要传参
ruby bin/image_spider2.rb

# 爬取日文WIKI资料
# 类型：unit 或 monster
ruby bin/wiki_spider.rb [类型]

# 合并用户提交的数据（已审核数据）
ruby bin/update_path.rb

# 部属新数据，网页到Github Pages
# 需要联系我，开通项目写权限
ruby bin/website_deploy.rb
```

Android版
---
__请查看android目录__

因为图包较大，直接打包进APP，导致APP占用过多手机内存，楼主也没有流量足够大的服务器放更新包，所以新版APP将分为APK和图包两部分了呦♪~

下载APP后，左侧侧边栏里的加载数据包，选中图包（MerusutoChristina.zip）即可了呦♪~

同时，魔宠和同伴界面的切换按钮也移入侧边栏了呦♪~

iOS版
---
__请查看ios目录__

第一版刚完成，功能还比较少，正在等待App Store审核上线。

Web网页版
---
__请查看website目录__

手机网页版
桌面网页版
=======
MerusutoChristina
=================
>>>>>>> Kagami-src/master

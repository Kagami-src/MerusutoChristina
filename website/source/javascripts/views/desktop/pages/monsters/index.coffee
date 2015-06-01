#= require views/desktop/pages/units/index
#= require views/desktop/pages/monsters/navbar_extra

class App.Pages.MonstersIndex extends App.Pages.UnitsIndex
  template: _.loadTemplate("templates/desktop/pages/units/index")
  navbarExtraClass: App.Pages.MonstersNavbarExtra

  initDataTableColumns: ->
    @columns = [
      data: null
      colvis: false
      orderable: false
      render: (data, type, model) => "<img class='icon' src='#{model.iconUrl()}' />"
    ,
      title: "稀有度"
      data: (model) -> model.get("rare")
      render: (data, type, model) -> model.getRareString()
    ,
      title: "ID"
      data: (model) -> model.id
    ,
      title: "名称"
      data: (model) -> model.getTitleString()
    ,
      title: "属性"
      data: (model) -> model.get("element")
      render: (data, type, model) -> model.getElementString()
    ,
      title: "生命"
      data: (model) -> model.get("life")
    ,
      title: "攻击"
      data: (model) -> model.get("atk")
    ,
      title: "攻距"
      data: (model) -> model.get("aarea")
    ,
      title: "攻数"
      data: (model) -> model.get("anum")
    ,
      title: "攻速"
      data: (model) -> model.get("aspd")
    ,
      title: "韧性"
      data: (model) -> model.get("tenacity")
    ,
      title: "移速"
      data: (model) -> model.get("mspd")
    ,
      title: "皮肤"
      data: (model) -> model.get("skin")
      render: (data, type, model) -> model.getSkinString()
    ,
      title: "DPS"
      data: (model) -> model.get("dps")
    ,
      title: "总DPS"
      data: (model) -> model.get("mdps")
    ,
      title: "技能"
      data: (model) -> model.get("skill-sc")
    ,
      title: "技能CD"
      data: (model) -> model.get("sklcd")
      visible: false
    ,
      title: "技能消耗"
      data: (model) -> model.get("sklsp")
      visible: false
    ,
      title: "火"
      data: (model) -> Math.round(model.get("fire")*100)
      render: (data) -> data + "%"
      visible: false
    ,
      title: "水"
      data: (model) -> Math.round(model.get("aqua")*100)
      render: (data) -> data + "%"
      visible: false
    ,
      title: "风"
      data: (model) -> Math.round(model.get("wind")*100)
      render: (data) -> data + "%"
      visible: false
    ,
      title: "光"
      data: (model) -> Math.round(model.get("light")*100)
      render: (data) -> data + "%"
      visible: false
    ,
      title: "暗"
      data: (model) -> Math.round(model.get("dark")*100)
      render: (data) -> data + "%"
      visible: false
    ,
      data: null
      colvis: false
      orderable: false
      render: (data, type, model) =>
        "<a class='glyphicon glyphicon-search action-show' " +
          "href='#monsters/#{model.id}' data-toggle='tooltip' " +
          "data-placement='top' title='查看详细信息'></a>" +
        "<a class='glyphicon glyphicon-pencil action-edit' " +
          "href='#monsters/#{model.id}/edit' data-toggle='tooltip' " +
          "data-placement='top' title='数据补全 / 报错'></a>"
    ]

#= require views/desktop/pages/units/navbar_extra

class App.Pages.UnitsIndex extends Backbone.View
  template: _.loadTemplate("templates/desktop/pages/units/index")
  navbarExtraClass: App.Pages.UnitsNavbarExtra

  events:
    "click tbody tr": "openShowPage"

  matchValue: ->
    model = arguments[3]
    filters = model.collection.filters
    for key, filter of filters
      attr = model.get(key)
      continue if _.isFunction(filter) && filter(attr)
      continue if _.isArray(filter) && filter.indexOf(attr) >= 0
      continue if filter == attr
      return false
    return true

  openShowPage: (event) ->
    return if $(event.target).is("a[href]")
    @$target = $(event.currentTarget)
    href = @$target.find(".action-show").attr("href")
    App.router.navigate(href, true)

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
      title: "武器"
      data: (model) -> model.get("weapon")
      render: (data, type, model) -> model.getWeaponString()
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
      title: "成长"
      data: (model) -> model.get("type")
      render: (data, type, model) -> model.getTypeString()
    ,
      title: "DPS"
      data: (model) -> model.get("dps")
    ,
      title: "总DPS"
      data: (model) -> model.get("mdps")
    ,
      title: "国家"
      data: (model) -> model.get("country")
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
      render: @renderActions
    ]

  renderActions: (data, type, model) ->
    "<a class='glyphicon glyphicon-search action-show' " +
      "href='#units/#{model.id}' data-toggle='tooltip' " +
      "data-placement='top' title='查看详细信息'></a>" +
    "<a class='glyphicon glyphicon-pencil action-edit' " +
      "href='#units/#{model.id}/edit' data-toggle='tooltip' " +
      "data-placement='top' title='数据补全 / 报错'></a>" +
    "<a class='glyphicon glyphicon-stats action-compare' " +
      "href='#units/#{model.id}/compare' data-toggle='tooltip' " +
      "data-placement='top' title='数据比较'></a>"

  afterRender: ->
    $.fn.dataTableExt.sErrMode = -> undefined

    @initDataTable()
    @initNavbarExtra()

    @$('[data-toggle="tooltip"]').tooltip()

  initDataTable: ->
    @initDataTableColumns()

    @collection.filters = {}
    $.fn.dataTableExt.afnFiltering.push @matchValue

    @$dataTable = @$("table").dataTable
      autoWidth: false
      columns: @columns
      data: @collection.models
      displayLength: 50
      dom: "<'row'<'col-sm-12'tr>>" +
        "<'row'<'col-sm-6'i><'col-sm-6'p>>"
      order: [[1, 'desc']]
      language:
        processing:   "处理中..."
        lengthMenu:   "显示 _MENU_ 项结果"
        zeroRecords:  "没有匹配结果"
        info:         "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项"
        infoEmpty:    "显示第 0 至 0 项结果，共 0 项"
        infoFiltered: "(由 _MAX_ 项结果过滤)"
        infoPostFix:  ""
        search:       "搜索:"
        url:          ""
        paginate:
          first:    "首页"
          previous: "上页"
          next:     "下页"
          last:     "末页"
    @dataTable = @$dataTable.api()

  pause: ->
    @scrollTop = $(window).scrollTop()
    @navbarExtra.$el.hide()

  resume: ->
    _.defer =>
      $(window).scrollTop(@scrollTop)
      if @$target
        @$target.pulse
          opacity: 0.5
        ,
          duration: 500
          pulses: 3
    @navbarExtra.$el.show()

  initNavbarExtra: ->
    @$colvis = new $.fn.dataTable.ColVis @$dataTable
    @navbarExtra = new @navbarExtraClass(index: @)
    $("#navbar-extra").html(@navbarExtra.render().$el)

  afterRemove: ->
    $.fn.dataTableExt.afnFiltering.pop()
    @navbarExtra.remove()

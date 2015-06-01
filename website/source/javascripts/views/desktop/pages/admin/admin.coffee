class App.Pages.Admin extends Backbone.View
  template: _.loadTemplate("templates/desktop/pages/admin/index")

  events:
    "click .action-accept": "accept"
    "click .action-reject": "reject"

  setState: (event, state) ->
    id = $(event.target).data("model-id")
    for data in @dataTable.data()
      model = data if data.id == id
    model.set "state", state
    model.save
      success: =>
        @dataTable.rows().invalidate().draw()

  accept: (event) ->
    @setState(event, 1)

  reject: (event) ->
    @setState(event, 2)

  afterRender: ->
    query = new AV.Query("Suggestion").descending("createdAt").limit(1000)
    query.find
      success: (models) =>
        # Do something with the returned AV.Object values
        @models = models
        @initDataTable()
        @initNavbarExtra()

        @$('[data-toggle="tooltip"]').tooltip()

    @columns = [
      title: "ID"
      data: (model) -> model.get("model") || {}
      render: (data) -> "#{data.klass}/#{data.id} #{data.name}"
    ,
      title: "修改"
      data: (model) -> model.get("data") || {}
      render: (data) ->
        $changelog = $("<ul></ul>")
        for d in data
          $changelog.append("<li>#{App.KeyMap[d.name]}： #{d.from} => #{d.to}</li>")
        $changelog.html()
    ,
      title: "数据提供者"
      data: (model) -> model.get("contributor") || {}
      render: (data) ->
        if data.nickname? && data.nickname != "" && data.contact? && data.contact != ""
          "#{data.nickname}(#{data.contact})"
        else
          data.nickname || data.contact || "匿名"
    ,
      title: "提交时间"
      data: (model) -> model.createdAt
      render: (data) -> data.toLocaleDateString?() || data.toDateString()
    ,
      title: "状态"
      data: (model) -> model.get("state") || 0
      render: (data) ->
        ["等待审核","审核通过","审核拒绝","数据已合并","数据已作废"][data]
    ,
      data: null
      orderable: false
      render: (data, type, model) =>
        return "" if model.get("state") == 3 || model.get("state") == 4
        "<a class='glyphicon glyphicon-ok action-accept' data-model-id='#{model.id}'" +
          "data-toggle='tooltip' data-placement='top' title='审核通过'></a>" +
        "<a class='glyphicon glyphicon-remove action-reject'  data-model-id='#{model.id}'" +
          "data-toggle='tooltip' data-placement='top' title='审核拒绝'></a>"
    ]

  initDataTable: ->
    @$dataTable = @$("table").dataTable
      autoWidth: false
      columns: @columns
      data: @models
      dom: "<'row'<'col-sm-12'tr>>" +
        "<'row'<'col-sm-6'i><'col-sm-6'p>>"
      order: [[3, 'desc']]
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

  initNavbarExtra: ->
    @navbarExtra = new App.Pages.AdminNavbarExtra(index: @)
    $("#navbar-extra").html(@navbarExtra.render().$el)

  resume: -> undefined

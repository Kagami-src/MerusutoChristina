class App.Pages.UnitsEdit extends Backbone.View
  template: _.loadTemplate("templates/desktop/pages/units/edit")

  events:
    "submit form": "submitForm"
    "click #confirm-button": "confirmSubmitForm"

  afterRender: ->
    query = new AV.Query("Suggestion")
    query.equalTo("state", null)
    query.equalTo("model.klass", @model.klass)
    query.equalTo("model.id", @model.id)
    query.count
      success: (count) =>
        @$("#editing-warning").show() if count > 0

  formatValue: (data) ->
    value = data.value
    if data.name in ["fire", "aqua", "wind", "light", "dark"] && value > 10
      value /= 100
    value

  matchValue: (data, value) ->
    return false unless data.value?
    return false if data.value == ""
    if _.isNumber(value)
      return parseFloat(data.value) != value
    else
      return data.value.replace("\r\n", "\n") != value

  submitForm: (event) ->
    event.preventDefault()

    @rawData = {}
    @changedData = []
    for data in @$("form").serializeArray()
      @rawData[data.name] = data.value
      continue if data.name in ["nickname", "contact"]
      value = @model.get(data.name)
      if @matchValue(data, value)
        @changedData.push
          name: data.name
          from: value || "暂缺"
          to: @formatValue(data)

    if @changedData.length > 0
      $changelog = @$("#changelog").empty()
      for data in @changedData
        $changelog.append("<li>#{App.KeyMap[data.name]}： #{data.from} => #{data.to}</li>")
      @$confirmModal = @$("#confirm-modal").modal()
    else
      App.main.openInfoModal("提交数据", "<p>您没有修改任何数据！</p>")

  confirmSubmitForm: ->
    @$confirmModal.modal("hide")
    suggestion = AV.Object.new("Suggestion")
    suggestion.set "model",
      klass: @model.klass
      id: @model.id
      name: @model.getTitleString()
    suggestion.set "contributor",
      nickname: @rawData["nickname"]
      contact: @rawData["contact"]
    suggestion.set("data", @changedData)
    suggestion.save
      success: ->
        App.main.openInfoModal("提交数据", """
          <p>您提交的数据已被记录，等待管理员审核中...</p>
          <p>
            您提交的数据在被管理员审核后，将会更新到图鉴中；<br>
            同时您的昵称也将会加入图鉴数据提供者名单，感谢您对图鉴的热情与贡献！
          </p>""")
      error: ->
        App.main.openInfoModal("提交数据", "<p>网络错误，请稍候再试...</p>")

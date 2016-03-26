class App.Pages.LoginModal extends Backbone.View
  template: _.loadTemplate("templates/desktop/modals/login")

  events:
    "submit form": "submitForm"

  submitForm: (event) ->
    event.preventDefault()

    username = @$("#username").val()
    password = @$("#password").val()

    AV.User.logIn username, password,
      success: =>
        App.main.closeModal()
        @callback?()
      error: ->
        App.main.openInfoModal("用户登录", "<p>用户名或密码错误！</p>")

  afterRender: (callback) ->
    @callback = callback

window.Ratchet = {}

window.App =

  Bindings: {}
  Utils: {}

  Widgets: {}
  Views: {}
  Pages: {}

  Collections: {}
  Models: {}

  initialize: ->
    _.setDebugLevel(2)

    @main = new App.Views.Main
      el: $('body')
    @main.render()

    @router = new App.Router()

    # Start backbone history
    Backbone.history.start()

$ ->
  AV.initialize(
    "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
    "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg"
    ) if AV?
  App.initialize()

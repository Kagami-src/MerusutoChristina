#= require ./container
#= require ./modal

class App.Views.Main extends Backbone.View
  template: _.loadTemplate("templates/mobile/main")

  layout:
    "container": App.Views.Container
    "modal": App.Views.Modal

  events:
    "click a[sref]": "loadState"
    "click a[href^='#']": "closeSidebar"

  loadState: (event) ->
    # load url & run callback defined in AppRouter without change hash
    url = $(event.currentTarget).attr("sref")
    Backbone.history.loadUrl(url)
    event.preventDefault()

  toggleSidebar: ->
    @views["container"].toggleSidebar()

  openSidebar: ->
    @views["container"].openSidebar()

  closeSidebar: ->
    @views["container"].closeSidebar()

  openModal: (view) ->
    @views["modal"].render(view).show()

  closeModal: () ->
    @views["modal"].hide()

  openPage: (view) ->
    @views["container"].render(view)

#= require ./page

MAX_CLICK_DURATION = 200
MAX_CLICK_DISTANCE = 5

class App.Views.Modal extends App.Views.Page

  show: ->
    @$el.modal("show")

  hide: ->
    @$el.modal("hide")

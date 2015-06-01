#= require ./page

MAX_CLICK_DURATION = 200
MAX_CLICK_DISTANCE = 5

class App.Views.Modal extends App.Views.Page
  template: undefined

  events:
    "touchstart": "onTouchStart"
    "touchend": "onTouchEnd"
    "mousedown": "onMouseDown"
    "mouseup": "onMouseUp"

  onTouchStart: (event) ->
    @onMouseDown(@_imitateMouseEvent(event))
  onTouchEnd: (event) ->
    @onMouseUp(@_imitateMouseEvent(event))

  _imitateMouseEvent: (event) ->
    event.pageX = event.touches[0].pageX
    event.pageY = event.touches[0].pageY
    event

  onMouseDown: (event) ->
    @lastClick =
      timestamp: Date.now()
      pageX: event.pageX
      pageY: event.pageY

  onMouseUp: (event) ->
    duration = Date.now() - @lastClick.timestamp
    distance = Math.sqrt(Math.pow(event.pageX - @lastClick.pageX, 2) +
      Math.pow(event.pageY - @lastClick.pageY, 2))
    if duration < MAX_CLICK_DURATION && distance < MAX_CLICK_DISTANCE
      event.stopPropagation()
      event.preventDefault()
      @hide()

  show: ->
    @$el.addClass("active")

  hide: ->
    @$el.removeClass("active")

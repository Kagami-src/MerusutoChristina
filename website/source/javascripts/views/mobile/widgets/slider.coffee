#= require decorators/ratchet/sliders

class App.Widgets.Slider extends Backbone.View
  events:
    "touchstart": "onTouchStart"
    "touchmove": "onTouchMove"
    "touchend": "onTouchEnd"
    "mousedown": "onMouseDown"
    "mousemove": "onMouseMove"
    "mouseup": "onMouseUp"
    "mouseup .slide-next": "slideToNext"
    "mouseup .slide-prev": "slideToPrev"

  afterRender: ->
    @slider = @$(".slide-group").get(0)
    @slideNumber = 0

  getScroll: ->
    if @slider.style.webkitTransform?
      translate3d = @slider.style.webkitTransform.match(/translate3d\(([^,]*)/)
      offsetX = if translate3d then translate3d[1] else 0
      parseInt(offsetX, 10)

  setSlideNumber: (offset) ->
    round = if offset then (if @deltaX < 0 then 'ceil' else 'floor') else 'round'
    slideNumber = Math[round](@getScroll() / (@scrollableArea / @slider.children.length))
    slideNumber += offset
    slideNumber = Math.min(slideNumber, 0)
    slideNumber = Math.max(-(@slider.children.length - 1), slideNumber)
    @slideNumber = slideNumber

  onTouchStart: (event) ->
    firstItem  = @$('.slide').get(0)

    @scrollableArea = firstItem.offsetWidth * @slider.children.length
    @isScrolling    = undefined
    @sliderWidth    = @slider.offsetWidth
    @resistance     = 1
    @lastSlide      = -(@slider.children.length - 1)
    @startTime      = +new Date()
    @pageX          = event.touches[0].pageX
    @pageY          = event.touches[0].pageY
    @deltaX         = 0
    @deltaY         = 0

    @setSlideNumber(0)

    @slider.style['-webkit-transition-duration'] = 0

  onTouchMove: (event) ->
    if (event.touches.length > 1)
      return # Exit if a pinch

    @deltaX = event.touches[0].pageX - @pageX
    @deltaY = event.touches[0].pageY - @pageY
    @pageX  = event.touches[0].pageX
    @pageY  = event.touches[0].pageY

    @isScrolling ||= Math.abs(@deltaY) > Math.abs(@deltaX)
    return if @isScrolling

    offsetX = (@deltaX / @resistance) + @getScroll()

    event.preventDefault()

    @resistance = if @slideNumber == 0 && @deltaX > 0 then (@pageX / @sliderWidth) + 1.25 else
      if @slideNumber == @lastSlide && @deltaX < 0 then (Math.abs(@pageX) / @sliderWidth) + 1.25 else 1

    @slider.style.webkitTransform = 'translate3d(' + offsetX + 'px,0,0)'

  onTouchEnd: (event) ->
    return if @isScrolling

    offset = if (+new Date()) - @startTime < 1000 && Math.abs(@deltaX) > 15 then (if @deltaX < 0 then -1 else 1) else 0
    @setSlideNumber(offset)

    offsetX = @slideNumber * @sliderWidth

    @slider.style['-webkit-transition-duration'] = '.2s'
    @slider.style.webkitTransform = 'translate3d(' + offsetX + 'px,0,0)'

    event = new CustomEvent('slide', {
      detail: { slideNumber: Math.abs(@slideNumber) },
      bubbles: true,
      cancelable: true
    })

    @slider.parentNode.dispatchEvent(event)

  slideTo: (event, slideNumber) ->
    offsetX = slideNumber * @sliderWidth

    @slider.style['-webkit-transition-duration'] = '.2s'
    @slider.style.webkitTransform = 'translate3d(' + offsetX + 'px,0,0)'

  slideToNext: (event) ->
    @setSlideNumber(-1)
    @slideTo(event, @slideNumber)
    event.stopPropagation()
    event.preventDefault()

  slideToPrev: (event) ->
    @setSlideNumber(1)
    @slideTo(event, @slideNumber)
    event.stopPropagation()
    event.preventDefault()

  _imitateTouchEvent: (event) ->
    event.touches ||= [_.pick(event, "pageX", "pageY")]
    event

  onMouseDown: (event) ->
    if @mouseIsDown
      event.stopPropagation()
      event.preventDefault()
    @mouseIsDown = true
    @onTouchStart(@_imitateTouchEvent(event))
  onMouseMove: (event) ->
    @onTouchMove(@_imitateTouchEvent(event)) if @mouseIsDown
  onMouseUp: (event) ->
    @mouseIsDown = false
    @onTouchEnd(@_imitateTouchEvent(event))

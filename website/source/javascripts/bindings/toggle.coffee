class App.Bindings.Toggle
  event: "click"

  constructor: (selector) ->
    @selector = selector
  
  onSet: ($el, model, attr) ->
    $el.toggleClass("active")
    model.set(attr, $el.hasClass("active"))
    
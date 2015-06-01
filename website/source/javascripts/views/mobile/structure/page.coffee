class App.Views.Page extends Backbone.View
  template: _.loadTemplate("templates/mobile/page")

  afterRender: (view) ->
    if view?
      @view.remove() if @view?
      @view = view
      @$el.html(view.$el)

  afterRemove: ->
    @view.remove() if @view?

  show: ->
    @$el.addClass("sliding right")
    _.defer =>
      # Make sure addClass is called after the dom has been appended
      # by calling `@el.offsetWidth'
      @el.offsetWidth
      @$el.removeClass("right")

  hide: ->
    @$el.addClass("left")

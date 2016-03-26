class App.Views.Page extends Backbone.View

  afterRender: (view) ->
    if view?
      @view.remove() if @view?
      @view = view
      @$el.html(view.$el || view)

  afterRemove: ->
    @view.remove() if @view?

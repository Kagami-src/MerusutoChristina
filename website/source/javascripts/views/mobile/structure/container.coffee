class App.Views.Container extends Backbone.View
  template: undefined

  afterRender: (view, reverse = false) ->
    if view?
      @lastPage.remove() if @lastPage?
      @lastPage = @currPage
      @currPage = new App.Views.Page().render(view)
      @currPage.$el.appendTo(@$el)
      if @lastPage?
        @lastPage.hide()
        @currPage.show()

  onClickSidebarActive: (event) =>
    @toggleSidebar()
    event.stopImmediatePropagation()
    event.preventDefault()

  toggleSidebar: ->
    @$el.toggleClass("sidebar-active")
    if @$el.hasClass("sidebar-active")
      @$el.on "click", @onClickSidebarActive
    else
      @$el.off "click", @onClickSidebarActive

  openSidebar: ->
    @$el.addClass("sidebar-active")
    @$el.on "click", @onClickSidebarActive

  closeSidebar: ->
    @$el.removeClass("sidebar-active")
    @$el.off "click", @onClickSidebarActive

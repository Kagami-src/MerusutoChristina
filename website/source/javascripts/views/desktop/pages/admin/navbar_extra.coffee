class App.Pages.AdminNavbarExtra extends Backbone.View
  template: _.loadTemplate("templates/desktop/pages/admin/navbar_extra")

  events:
    "click .dropdown-submenu > a": "triggerHover"
    "click .state": "setState"
    "click .page": "setPage"
    "change #search": "search"
    "keyup #search": "search"

  afterInitialize: (options) ->
    @index = options["index"]

  triggerHover: (event) ->
    $(event.target).trigger('hover')
    event.stopPropagation()

  removeAllActive: ($target) ->
    $target.closest('.dropdown-menu').find('.active').removeClass('active')

  setActive: ($target) ->
    @removeAllActive($target)
    $target.parent('li').toggleClass("active")

  setState: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    @index.dataTable.column(-2).search(key).draw()

  search: (event) ->
    $target = $(event.target)
    query = $target.val()
    @index.dataTable.search(query).draw()

  setPage: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    @index.dataTable.page.len(key).draw()

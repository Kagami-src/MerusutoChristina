class App.Pages.UnitsItem extends Backbone.View
  template: _.loadTemplate("templates/mobile/pages/units/item")

  bindings:
    "#life": "life"
    "#atk": "atk"
    "#dps": "dps"
    "#mdps": "mdps"

class App.Pages.UnitsIndex extends Backbone.View
  template: _.loadTemplate("templates/mobile/pages/units/index")

  store:
    selector: ".table-view"
    template: App.Pages.UnitsItem
    infinite:
      container: ".content"
      suffix: true

  events:
    "click .dropdown-toggle": "toggleDropdown"
    "click .dropdown-submenu > a": "triggerHover"
    "click .filter-reset": "resetFilter"
    "click .filter": "setFilter"
    "click .sort-mode": "setSortMode"
    "click .level-mode": "setLevelMode"
    "click .search-open": "openSearch"
    "click .search-close": "closeSearch"

  afterRender: ->
    @filters = {}
    @binder.filter(@filters)

    $content = @$el.filter(".content")
    $scroll = @$el.filter(".scroll-to-top")
    $scroll.click ->
      $content.scrollToTop()
    @$el.scroll (event) ->
      if event.target.scrollTop > 1000
        $scroll.addClass("in")
      else
        $scroll.removeClass("in")

    @appendFilters()

  appendFilters: ->
    $aarea = @$("#aarea")
    $aarea.find(".filter").each ->
      $target = $(this)
      original = $target.data("value").split("-")
      min = parseInt(original[0])
      max = parseInt(original[1])

      $target.data "value", (value) ->
        return false if min > value
        return false if max < value
        return true

    $country = @$("#country")

    appendCountryFilter = (collection) ->
      countries = collection.map (model) ->
        model.get("country")
      countries = _.uniq(countries)
      for country in countries
        $country.append(
          """<li><a class="filter" data-key="country" data-value="#{country}">#{country}</a></li>"""
          )

    if $country.length > 0
      if @collection.length == 0
        @collection.once "reset", (collection) =>
          appendCountryFilter(collection)
      else
        appendCountryFilter(@collection)

  triggerHover: (event) ->
    $(event.target).trigger('hover')
    event.stopPropagation()

  toggleDropdown: (event) ->
    $dropdown = $(event.target).parent(".dropdown")
    if $dropdown.hasClass("active")
      $dropdown.removeClass("active")
    else
      $(".dropdown.active").removeClass("active")
      $dropdown.addClass("active")
    $dropdown.closest(".container").one "click", ->
      $dropdown.removeClass("active")
    event.stopPropagation()

  openSearch: (event) ->
    $children = $(event.target).closest("header").children()
    $search = $children.filter(".input-search")
    $children.not($search).hide()
    $search.show()
    $input = $search.children("input")
    $input.trigger("focus").val("")
    @searchInterval = setInterval =>
      query = $input.val()
      @search(query)
    , 200

  closeSearch: (event) ->
    @binder.filter(@filters)
    clearInterval(@searchInterval) if @searchInterval
    $children = $(event.target).closest("header").children()
    $search = $children.filter(".input-search")
    $children.not($search).show()
    $search.hide()

  search: (query) ->
    if query != @searchQuery
      @binder.filter (collection) =>
        models = if _.isEmpty(@filters)
            collection.models
          else
            collection.where(@filters)
        if query != ""
          models = _.filter models, (model) ->
            for key in ["id", "name", "title"]
              value = model.get(key)
              if value && value.toString().indexOf(query) >= 0
                return true
            false
        models
      @searchQuery = query

  resetFilter: (event) ->
    $target = $(event.target)
    @removeAllActive($target)
    if key = $target.data("key")
      delete @filters[key]
    else
      @filters = {}
    @binder.filter(@filters)

  removeAllActive: ($target) ->
    $target.closest('.dropdown-menu').find('.active').removeClass('active')

  setActive: ($target) ->
    @removeAllActive($target)
    $target.parent('li').toggleClass("active")

  setFilter: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    value = $target.data("value")
    filters = {}
    filters[key] = value
    @filters[key] = value
    @binder.filter(@filters)

  setSortMode: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    @binder.sort (model) ->
      value = model.get(key)
      if value?.toString()  == "NaN" || !value? then 0 else -value

  setLevelMode: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    @binder.collection.each (model) ->
      model.setLevelMode(key)

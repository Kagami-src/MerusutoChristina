class App.Pages.UnitsNavbarExtra extends Backbone.View
  template: _.loadTemplate("templates/desktop/pages/units/navbar_extra")

  events:
    "click #colvis li": "stopPropagation"
    "click .dropdown-submenu > a": "triggerHover"
    "click .filter-reset": "resetFilter"
    "click .filter": "setFilter"
    "click .level-mode": "setLevelMode"
    "click .page": "setPage"
    "change #search": "search"
    "keyup #search": "search"

  afterInitialize: (options) ->
    @index = options["index"]

  afterRender: ->
    @initColvis()
    @initDropdown()

  initColvis: ->
    $colvis = @$("#colvis")
    for column, index in @index.columns
      continue if column.colvis? && !column.colvis
      $button = $(@index.$colvis._fnDomColumnButton(index))
      $checkbox = $button.find("input[type=checkbox]")
      $checkbox.attr("checked", !column.visible? || column.visible)
      $colvis.append $button

  initDropdown: ->
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
    countries = @index.collection.map (model) ->
      model.get("country")
    countries = _.uniq(countries)
    for country in countries
      $country.append(
        """<li><a class="filter" data-key="country" data-value="#{country}">#{country}</a></li>"""
        )

  stopPropagation: (event) ->
    event.stopPropagation()

  triggerHover: (event) ->
    $(event.target).trigger('hover')
    event.stopPropagation()

  removeAllActive: ($target) ->
    $target.closest('.dropdown-menu').find('.active').removeClass('active')

  setActive: ($target) ->
    @removeAllActive($target)
    $target.parent('li').toggleClass("active")

  resetFilter: (event) ->
    $target = $(event.target)
    @removeAllActive($target)
    if key = $target.data("key")
      delete @index.collection.filters[key]
    else
      @index.collection.filters = {}
    @index.dataTable.draw()

  setFilter: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    value = $target.data("value")
    @index.collection.filters[key] = value
    @index.dataTable.draw()

  setLevelMode: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    for model in @index.dataTable.data()
      model.setLevelMode(key)
    @index.dataTable.rows().invalidate().draw(false)

  search: (event) ->
    $target = $(event.target)
    query = $target.val()
    @index.dataTable.search(query).draw()

  setPage: (event) ->
    $target = $(event.target)
    @setActive($target)
    key = $target.data("key")
    @index.dataTable.page.len(key).draw()

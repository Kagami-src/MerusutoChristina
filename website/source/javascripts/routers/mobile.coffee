class App.Router extends Backbone.Router

  routes:
    "toggle-sidebar": "toggleSidebar"
    "close-modal": "closeModal"

    "units": "openUnitsIndexPage"
    "units/:id": "openUnitsShowPage"
    "monsters": "openMonstersIndexPage"
    "monsters/:id": "openMonstersShowPage"

    "!*otherwise": "removeExclamationMark"
    "*otherwise": "index"

  toggleSidebar: ->
    App.main.toggleSidebar()

  closeModal: ->
    App.main.closeModal()

  index: ->
    @navigate("#units", true)

  removeExclamationMark: (path) ->
    @navigate(path, true)

  openCollectionPage: (key, collection, page) ->
    unless App[key]?
      App[key] = new App.Collections[collection]()
      App[key].fetch(reset: true)
    view = new App.Pages[page](collection: App[key])
    App.main.openPage(view.render())
    @track()

  openModelPage: (key, collection, page, id) ->
    return @navigate("##{key}", true) unless App[key]?
    model = App[key].get(id)
    view = new App.Pages[page](model: model)
    App.main.openModal(view.render())
    @track()

  openUnitsIndexPage: ->
    @openCollectionPage "units", "Units", "UnitsIndex"

  openUnitsShowPage: (id) ->
    @openModelPage "units", "Units", "UnitsShow", id

  openMonstersIndexPage: ->
    @openCollectionPage "monsters", "Monsters", "MonstersIndex"

  openMonstersShowPage: (id) ->
    @openModelPage "monsters", "Monsters", "MonstersShow", id

  track: ->
    if ga?
      url = Backbone.history.getFragment()
      # Add a slash if neccesary
      url = '/' + url if (!/^\//.test(url))
      # Record page view
      ga('send', hitType: 'pageview', page: url)

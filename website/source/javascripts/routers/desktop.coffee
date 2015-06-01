class App.Router extends Backbone.Router

  routes:
    "close-modal": "closeModal"

    "units": "openUnitsIndexPage"
    "units/:id": "openUnitsShowPage"
    "units/:id/edit": "openUnitsEditPage"
    "units/:id/compare": "openUnitsComparePage"
    "units/:id1/compare/:id2": "openUnitsDoubleComparePage"
    "monsters": "openMonstersIndexPage"
    "monsters/:id": "openMonstersShowPage"
    "monsters/:id/edit": "openMonstersEditPage"
    "monsters/:id/compare": "openMonstersComparePage"
    "monsters/:id1/compare/:id2": "openMonstersDoubleComparePage"

    "admin": "openAdminPage"

    "!*otherwise": "removeExclamationMark"
    "*otherwise": "index"

  closeModal: ->
    App.main.closeModal()

  index: ->
    @navigate("#units", true)

  removeExclamationMark: (path) ->
    @navigate(path, true)

  ensureCollection: (key, collection, callback) ->
    if App[key]?
      callback()
    else
      App[key] = new App.Collections[collection]()
      App[key].fetch(reset: true)
      App[key].once "reset", ->
        callback()

  openCollectionPage: (key, collection, page) ->
    if @currCollection == collection
      App.main.resumeCollectionPage()
    else
      @ensureCollection key, collection, =>
        view = new App.Pages[page](collection: App[key]).render()
        App.main.openCollectionPage(view)
        @currCollection = collection
    @track()

  openModelPage: (key, collection, page, id) ->
    @ensureCollection key, collection, ->
      model = App[key].get(id)
      view = new App.Pages[page](model: model, collection: App[key]).render()
      App.main.openModelPage(view)
    @track()

  openDoubleModelPage: (key, collection, page, id1, id2) ->
    @ensureCollection key, collection, ->
      models = []
      models.push App[key].get(id2)
      models.push App[key].get(id1)
      view = new App.Pages[page](collection: models).render()
      App.main.openModelPage(view)
    @track()

  openAdminPage: ->
    @currCollection = null
    if AV.User.current()
      view = new App.Pages.Admin().render()
      App.main.openCollectionPage(view)
    else
      App.main.openLoginModal(@openAdminPage)
    @track()

  openUnitsIndexPage: ->
    @openCollectionPage "units", "Units", "UnitsIndex"

  openUnitsShowPage: (id) ->
    @openModelPage "units", "Units", "UnitsShow", id

  openUnitsEditPage: (id) ->
    @openModelPage "units", "Units", "UnitsEdit", id

  openUnitsComparePage: (id) ->
    @openModelPage "units", "Units", "UnitsCompare", id

  openUnitsDoubleComparePage: (id1, id2) ->
    @openDoubleModelPage "units", "Units", "UnitsDoubleCompare", id1, id2

  openMonstersIndexPage: ->
    @openCollectionPage "monsters", "Monsters", "MonstersIndex"

  openMonstersShowPage: (id) ->
    @openModelPage "monsters", "Monsters", "MonstersShow", id

  openMonstersEditPage: (id) ->
    @openModelPage "monsters", "Monsters", "MonstersEdit", id

  openMonstersComparePage: (id) ->
    @openModelPage "monsters", "Monsters", "MonstersCompare", id

  openMonstersDoubleComparePage: (id1, id2) ->
    @openDoubleModelPage "monsters", "Monsters", "MonstersDoubleCompare", id1, id2

  track: ->
    if ga?
      url = Backbone.history.getFragment()
      # Add a slash if neccesary
      url = '/' + url if (!/^\//.test(url))
      # Record page view
      ga('send', hitType: 'pageview', page: url)

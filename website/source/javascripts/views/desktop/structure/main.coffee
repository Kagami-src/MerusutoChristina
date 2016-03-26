#= require ./modal

class App.Views.Main extends Backbone.View
  template: _.loadTemplate("templates/desktop/main")
  navbar_links_template: _.loadTemplate("templates/desktop/navbar_links")

  layout:
    "#collectionView": App.Views.Page
    "#modelView": App.Views.Page
    "modal": App.Views.Modal

  events:
    "click a[sref]": "loadState"
    "click .action-login": "openLoginModal"
    "click .action-logout": "logout"

  logout: -> AV.User.logOut()

  loadState: (event) ->
    # load url & run callback defined in AppRouter without change hash
    url = $(event.currentTarget).attr("sref")
    Backbone.history.loadUrl(url)
    event.preventDefault()

  openModal: (view) ->
    @views["modal"].render(view).show()

  openInfoModal: (title, info) ->
    @infoModal ||= new App.Pages.InfoModal()
    @infoModal.render(title, info)
    @views["modal"].render(@infoModal).show()

  openLoginModal: (callback) ->
    @loginModal ||= new App.Pages.LoginModal()
    @loginModal.render(callback)
    @views["modal"].render(@loginModal).show()

  closeModal: () ->
    @views["modal"].hide()

  pauseCollectionPage: ->
    @views["#modelView"].$el.show()
    @views["#collectionView"].$el.hide()
    @views["#collectionView"].view?.pause?()
    @$("#navbar-links").html(@navbar_links_template())

  resumeCollectionPage: ->
    @views["#modelView"].$el.hide()
    @views["#collectionView"].$el.show()
    @views["#collectionView"].view.resume?()
    @$("#navbar-links").html(@navbar_links_template())

  openModelPage: (view) ->
    @$el.scrollTop(0)
    @views["#modelView"].render(view)
    @pauseCollectionPage()

  openCollectionPage: (view) ->
    @views["#collectionView"].render(view)
    @resumeCollectionPage()

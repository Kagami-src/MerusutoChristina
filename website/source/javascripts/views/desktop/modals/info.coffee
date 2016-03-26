class App.Pages.InfoModal extends Backbone.View
  template: _.loadTemplate("templates/desktop/modals/info")

  afterRender: (title, info) ->
    @$("#modal-title").html(title)
    @$("#modal-body").html(info)

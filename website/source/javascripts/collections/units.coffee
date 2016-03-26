class App.Collections.Units extends Backbone.Collection
  url: "../data/units.json"
  model: App.Models.Unit

  initialize: ->
    @comparator = (model) -> -model.get("rare")

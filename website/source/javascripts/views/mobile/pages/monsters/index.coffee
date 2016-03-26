#= require views/mobile/pages/units/index

class App.Pages.MonstersItem extends Backbone.View
  template: _.loadTemplate("templates/mobile/pages/monsters/item")

  bindings:
    "#life": "life"
    "#atk": "atk"
    "#dps": "dps"
    "#mdps": "mdps"

class App.Pages.MonstersIndex extends App.Pages.UnitsIndex
  template: _.loadTemplate("templates/mobile/pages/monsters/index")

  store: _.extend {}, App.Pages.UnitsIndex::store,
    template: App.Pages.MonstersItem

  appendFilters: ->
    $skill = @$("#skill")

    appendSkillFilter = (collection) ->
      skills = collection.map (model) ->
        model.get("skill-sc")
      skills = _.uniq(skills)
      for skill in skills
        $skill.append(
          """<li><a class="filter" data-key="skill-sc" data-value="#{skill}">#{skill}</a></li>"""
          )

    if $skill.length > 0
      if @collection.length == 0
        @collection.once "reset", (collection) =>
          appendSkillFilter(collection)
      else
        appendSkillFilter(@collection)

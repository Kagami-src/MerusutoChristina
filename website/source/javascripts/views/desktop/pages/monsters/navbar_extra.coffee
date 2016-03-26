#= require views/desktop/pages/units/navbar_extra

class App.Pages.MonstersNavbarExtra extends App.Pages.UnitsNavbarExtra
  template: _.loadTemplate("templates/desktop/pages/monsters/navbar_extra")

  initDropdown: ->
    $skill = @$("#skill")
    skills = @index.collection.map (model) ->
      model.get("skill-sc")
    skills = _.uniq(skills)
    for skill in skills
      $skill.append(
        """<li><a class="filter" data-key="skill-sc" data-value="#{skill}">#{skill}</a></li>"""
        )

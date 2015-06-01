#= require models/unit

class App.Models.Monster extends App.Models.Unit
  klass: "Monster"

  initialize: (attributes, options) ->
    @origin =
      atk: attributes.atk
      life: attributes.life
    @setLevelMode("sm")
    @origin.dps = @get('dps')
    @origin.mdps = @get('mdps')
    @set("skill-sc", @getSkillShortString())

  calcBySize: (value, size, mode) ->
    switch mode
      when 1
        Math.floor(value * Math.pow(size, 2.36))
      when 2
        Math.floor(value * size)
      else
        value

  setLevelMode: (mode) ->
    switch mode
      when "sm"
        atk = @origin.atk
        life = @origin.life
      when "md"
        atk = @calcBySize(@origin.atk, 1.35, 1)
        life = @calcBySize(@origin.life, 1.35, 2)
      when "lg"
        atk = @calcBySize(@origin.atk, 1.55, 1)
        life = @calcBySize(@origin.life, 1.55, 2)
      when "xl"
        atk = @calcBySize(@origin.atk, 1.7, 1)
        life = @calcBySize(@origin.life, 1.7, 2)
      when "xxl"
        atk = @calcBySize(@origin.atk, 1.8, 1)
        life = @calcBySize(@origin.life, 1.8, 2)

    dps = atk / @get("aspd")
    mdps = Math.round(dps * @get("anum"))
    dps = Math.round(dps)

    @set("atk", atk)
    @set("life", life)
    @set("dps", dps)
    @set("mdps", mdps)


  imageUrl: (type) ->
    "../data/monsters/#{type}/#{@id}.png"

  getTitleString: ->
    @get("name")

  getSkinString: ->
    @getIndexString(["坚硬", "常规", "柔软"], "skin")

  getSkillShortString: ->
    @get("skill").split("：")[0].split(/\s/g)[0]

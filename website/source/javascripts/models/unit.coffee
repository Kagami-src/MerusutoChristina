class App.Models.Unit extends Backbone.Model
  klass: "Unit"

  initialize: (attributes, options) ->
    @origin =
      atk: attributes.atk
      life: attributes.life
    @setLevelMode("zero")
    @origin.dps = @get('dps')
    @origin.mdps = @get('mdps')

  calcF: ->
    @f ||= 1.8 + 0.1 * @get("type")

  # 零觉满级
  calcMaxLv: (key) ->
    value = @origin[key]
    Math.floor(value * @calcF())

  # 满觉满级
  calcMaxLvAndGrow: (key) ->
    f = @calcF()
    rare = @get("rare")
    value = @origin[key]
    levelPart = Math.floor(value * f)
    growPart = Math.floor(value * (f - 1) / (19 + 10 * rare)) *
      5 * (if rare == 1 then 5 else 15)
    levelPart + growPart

  setLevelMode: (mode) ->
    switch mode
      when "zero"
        atk = @origin.atk
        life = @origin.life
      when "mxlv"
        atk = @calcMaxLv("atk")
        life = @calcMaxLv("life")
      when "mxlvgr"
        atk = @calcMaxLvAndGrow("atk")
        life = @calcMaxLvAndGrow("life")

    dps = atk / @get("aspd")
    mdps = Math.round(dps * @get("anum"))
    dps = Math.round(dps)

    @set("atk", atk)
    @set("life", life)
    @set("dps", dps)
    @set("mdps", mdps)

  imageUrl: (type) ->
    "../data/units/#{type}/#{@id}.png"

  iconUrl: ->
    @imageUrl("icon")

  thumbnailUrl: ->
    @imageUrl("thumbnail")

  originalUrl: ->
    @imageUrl("original")

  getTitleString: ->
    "#{@get("title")} #{@get("name")}"

  getIndexString: (strs, key) ->
    strs[@get(key) - 1] || "暂缺"

  getRareString: ->
    @getIndexString(["★", "★★", "★★★", "★★★★", "★★★★★"], "rare")

  getElementKey: ->
    @getIndexString(["fire", "aqua", "wind", "light", "dark"], "element")

  getElementString: ->
    @getIndexString(["火", "水", "风", "光", "暗"], "element")

  getWeaponString: ->
    @getIndexString(["斩击", "突击", "打击", "弓箭", "魔法", "铳弹", "回复"], "weapon")

  getTypeString: ->
    @getIndexString(["早熟", "平均", "晚成"], "type")

  getGenderString: ->
    @getIndexString(["不明", "男", "女"], "gender")

  getElementPercentString: (element) ->
    value = @get(element)
    if _.isNumber value then "#{Math.round(value*100)}%" else "暂缺"

  getAgeString: ->
    value = @get("age")
    if _.isNumber value then "#{value}岁" else "暂缺"

  getString: (key) ->
    @get(key) || "暂缺"

  getFormatString: (key) ->
    @getString(key).replace /ID(\d+)(\[[^\]]+\]\S+)?/g, (text, id) ->
      """<a href="#units/#{id}">#{text}</a>"""

  getElementPolygonPointsString: (l, r) ->
    es = [@get("fire"), @get("aqua"), @get("wind"), @get("light"), @get("dark")]
    c = { x: l/2, y: l/2 }
    ps = _.map [0..4], (i) ->
      a = (i * 72 - 90) * (Math.PI * 2) / 360
      { x: c.x+Math.cos(a)*r*es[i], y: c.y+Math.sin(a)*r*es[i] }
    App.Utils.SVG.getPolygonPointsString(ps)

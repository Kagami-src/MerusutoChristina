App.Mixins.Formatter =
  get: (key) ->
    @props.item[key]

  getString: (key) ->
    @get(key) || "暂缺"

  getFormatString: (key) ->
    @getString(key).replace /ID(\d+)(\[[^\]]+\]\S+)?/g, (text, id) ->
      """<a href="#units/#{id}">#{text}</a>"""

  hashUrl: -> "#/#{@type}s/#{@get("id")}"

  imageUrl: (imageType) ->
    "../data/#{@type}s/#{imageType}/#{@get("id")}.png"

  iconUrl: -> @imageUrl("icon")
  thumbnailUrl: -> @imageUrl("thumbnail")
  originalUrl: -> @imageUrl("original")

  getTitleString: -> "#{@get("title")} #{@get("name")}"

  getIndexString: (strs, key) -> strs[@get(key) - 1] || "暂缺"

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
    if typeof value == "number" then "#{Math.round(value*100)}%" else "暂缺"

  getAgeString: ->
    value = @get("age")
    if typeof value == "number" then "#{value}岁" else "暂缺"

  getElementPolygonPointsString: (l, r) ->
    es = [@get("fire"), @get("aqua"), @get("wind"), @get("light"), @get("dark")]
    c = { x: l/2, y: l/2 }
    ret = []
    for i in [0..4]
      a = (i * 72 - 90) * (Math.PI * 2) / 360
      ret.push { x: c.x+Math.cos(a)*r*es[i], y: c.y+Math.sin(a)*r*es[i] }
    @getPolygonPointsString(ret)


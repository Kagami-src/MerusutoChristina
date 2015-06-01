App.Utils.SVG =

  getPolygonPointsString: (ps) ->
    _.map ps, (p) ->
      "#{p.x},#{p.y}"
    .join(" ")
    
  getBackgroundPolygonPointsString: (l, r) ->
    return @bgs[r] if @bgs && @bgs[r]?

    c = { x: l/2, y: l/2 }
    ps = _.map [0..4], (i) ->
      a = (i * 72 - 90) * (Math.PI * 2) / 360
      { x: c.x+Math.cos(a)*r, y: c.y+Math.sin(a)*r }
    @bgs = {} unless @bgs
    @bgs[r] = App.Utils.SVG.getPolygonPointsString(ps)

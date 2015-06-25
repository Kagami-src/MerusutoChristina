App.Mixins.RenderPartials =
  separatePartials: (prefix) ->
    @["#{prefix}#{@props.partial}"]?() if @props.partial?

  inPartial: (partial, callback) ->
    callback.apply(@) if @props.partial == partial

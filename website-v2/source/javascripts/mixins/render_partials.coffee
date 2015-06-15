App.Mixins.RenderPartials =
  componentWillMount: ->
    if typeof @props.partial == "string"
      key = "render#{@props.partial}"
      if typeof @[key] == "function"
        @render = @[key]
      else
        @render = -> null

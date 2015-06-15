App.Components.WithScope = React.createClass
  displayName: "WithScope"
  whiteList: ['className', 'children']

  render: ->
    props = {}
    for key, value of @props
      props[key] = value unless @whiteList.indexOf(key) >= 0

    <div className={@props.className}>
      {
        React.Children.map @props.children, (child) ->
          React.cloneElement(child, props)
      }
    </div>

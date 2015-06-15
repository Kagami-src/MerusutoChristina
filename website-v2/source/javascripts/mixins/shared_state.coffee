ComponentGroups = {}

App.Mixins.SharedState = (key) ->
  components = ComponentGroups[key] ||= []

  componentWillMount: ->
    components.push @

  componentWillUnmount: ->
    index = components.indexOf @
    components.splice index, 1 if index >= 0

  getSharedStateComponents: ->
    components

  setSharedState: (nextState, callback) ->
    for component in components
      component.setState(nextState, callback)

  replaceSharedState: (nextState, callback) ->
    for component in components
      component.replaceState(nextState, callback)

{Route, Redirect} = ReactRouter

App.routes =
  <Route handler={App.Components.Main} path="/">
    <Route name="units" handler={App.Components.Units.Index}/>
    <Redirect from="" to="units"/>
  </Route>

App.initialize = ->
  ReactRouter.run App.routes, (Handler) ->
    React.render(<Handler/>, document.body)

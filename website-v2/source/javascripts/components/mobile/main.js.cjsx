App.Components.Main = React.createClass
  displayName: "Main"

  getInitialState: ->
    headerFilters: null

  handleHeaderFilters: (headerFilters) ->
    @setState({ headerFilters })

  render: ->
    <div className="main">
      <App.Components.Header/>
      <content className="content">
        <ReactRouter.RouteHandler/>
      </content>
    </div>

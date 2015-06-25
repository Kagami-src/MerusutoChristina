{RouteHandler} = ReactRouter

App.Components.Main = React.createClass
  displayName: "Main"

  render: ->
    <div className="main">
      <header className="bar bar-nav">
        <div className="input-icon input-search" style={{display: 'none'}}>
          <span className="icon icon-search"></span>
          <input type="search" placeholder="Search">
          <a className="icon icon-close pull-right"></a>
        </div>

        <a className="icon icon-bars pull-left"></a>
        <a className="icon icon-search pull-right"></a>

        <RouteHandler partial="HeaderFilters"/>
      </header>

      <content className="content">
        <RouteHandler partial="Main"/>
      </content>
    </div>

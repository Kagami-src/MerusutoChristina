App.Components.Header = React.createClass
  displayName: "Header"

  render: ->
    <header className="bar bar-nav">

      <div className="input-icon input-search" style={{display: 'none'}}>
        <span className="icon icon-search"></span>
        <input type="search" placeholder="Search">
        <a className="icon icon-close pull-right"></a>
      </div>

      <a className="icon icon-bars pull-left"></a>
      <a className="icon icon-search pull-right"></a>

      <ReactRouter.RouteHandler partial="HeaderFilters"/>

    </header>

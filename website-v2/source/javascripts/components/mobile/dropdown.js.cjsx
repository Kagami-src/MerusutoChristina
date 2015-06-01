App.Components.Dropdown = React.createClass
  displayName: "Dropdown"

  getInitialState: ->
    active: @props.active || false

  defer: (callback) ->
    setTimeout callback, 0

  toggleActive: (event) ->
    if @state.active
      @removeActive()
    else
      @defer => window.addEventListener("click", @removeActive)
      @setState(active: true)

  removeActive: ->
    @defer => window.removeEventListener("click", @removeActive)
    @setState(active: false)

  shouldComponentUpdate: (nextProps, nextState) ->
    nextState.active || @state.active

  render: ->
    <div className={classNames("dropdown pull-right", active: @state.active)}>
      <a className="btn btn-link dropdown-toggle" onClick={@toggleActive}>
        {@props.title}
      </a>
      <ul className="dropdown-menu">
        {
          React.Children.map @props.children, (child) =>
            React.cloneElement child,
              parentName: @props.name
        }
      </ul>
    </div>

App.Components.Dropdown.SubDropdown = React.createClass
  displayName: "SubDropdown"

  render: ->
    <li className="dropdown-submenu pull-left">
      <a>{@props.title}</a>
      <ul className="dropdown-menu">
        {
          React.Children.map @props.children, (child) =>
            React.cloneElement child,
              parentName: "#{@props.parentName}_#{@props.name}"
        }
      </ul>
    </li>

App.Components.Dropdown.Item = React.createClass
  displayName: "DropdownItem"
  mixins: [ReactRouter.State, ReactRouter.Navigation]

  handleClick: ->
    query = React.addons.update(@getQuery(), {})
    query[@props.parentName] = @props.value
    @transitionTo(@getPathname(), @getParams(), query)

  render: ->
    <li className={classNames(active: false)}>
      <a onClick={@handleClick}>{@props.title}</a>
    </li>

App.Components.Dropdown.Divider = React.createClass
  displayName: "DropdownDivider"

  render: ->
    <li className="divider"></li>

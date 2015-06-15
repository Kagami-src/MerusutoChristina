App.Components.Dropdown = React.createClass
  displayName: "Dropdown"
  propTypes:
    filters: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired

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

  handleChange: (change) ->
    (update = {})[@props.name] = change
    @props.onChange(update)

  render: ->
    <div className={classNames("dropdown pull-right", active: @state.active)}>
      <a className="btn btn-link dropdown-toggle" onClick={@toggleActive}>
        {@props.title}
      </a>
      <ul className="dropdown-menu">
        {
          React.Children.map @props.children, (child) =>
            React.cloneElement child,
              filters: @props.filters[@props.name]
              onChange: @handleChange
        }
      </ul>
    </div>

App.Components.Dropdown.SubDropdown = React.createClass
  displayName: "SubDropdown"

  handleChange: (change) ->
    (update = {})[@props.name] = change
    @props.onChange(update)

  render: ->
    <li className="dropdown-submenu pull-left">
      <a>{@props.title}</a>
      <ul className="dropdown-menu">
        {
          React.Children.map @props.children, (child) =>
            React.cloneElement child,
              filters: @props.filters[@props.name]
              onChange: @handleChange
        }
      </ul>
    </li>

App.Components.Dropdown.Item = React.createClass
  displayName: "DropdownItem"
  mixins: [ReactRouter.State, ReactRouter.Navigation]

  handleClick: ->
    @props.onChange($set: @props.value)

  render: ->
    <li className={classNames(active: @props.filters == @props.value)}>
      <a onClick={@handleClick}>{@props.title}</a>
    </li>

App.Components.Dropdown.Divider = React.createClass
  displayName: "DropdownDivider"

  render: ->
    <li className="divider"></li>

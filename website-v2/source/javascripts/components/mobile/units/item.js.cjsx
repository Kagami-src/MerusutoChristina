App.Components.Units.Item = React.createClass
  type: "unit"
  displayName: "UnitItem"
  mixins: [App.Mixins.SVG, App.Mixins.Formatter]

  shouldComponentUpdate: (nextProps, nextState) -> false

  render: ->
    <li className="table-view-cell media unit">
      <a href={@hashUrl()}>
        <img className="media-object pull-left" src={@thumbnailUrl()}/>
        <svg className="media-graphics element pull-right" width="80" height="80">
          <polygon xmlns="http://www.w3.org/2000/svg" points={@getBackgroundPolygonPointsString(80, 40)} className="element-background"/>
          <polygon xmlns="http://www.w3.org/2000/svg" points={@getBackgroundPolygonPointsString(80, 26.7)} className="element-background"/>
          <polygon xmlns="http://www.w3.org/2000/svg" points={@getBackgroundPolygonPointsString(80, 13.3)} className="element-background"/>
          <polygon xmlns="http://www.w3.org/2000/svg" points={@getElementPolygonPointsString(80, 20)} className={"element-#{key}" if key = @getElementKey()}/>
        </svg>
        <div className="media-body">
          <h4 className="media-title">
            {@getTitleString()}
            <small>{@getRareString()}</small>
          </h4>
          <div className="media-info-group">
            <p className="media-info">
              生命：<span id="life">{@getString("life")}</span><br/>
              攻击：<span id="atk">{@getString("atk")}</span><br/>
              攻距：{@getString("aarea")}<br/>
              攻数：{@getString("anum")}<br/>
            </p>
            <p className="media-info">
              攻速：{@getString("aspd")}<br/>
              韧性：{@getString("tenacity")}<br/>
              移速：{@getString("mspd")}<br/>
              多段：{@getString("hits")}<br/>
            </p>
            <p className="media-info hidden-xs">
              成长：{@getTypeString()}<br/>
              火：{@getElementPercentString("fire")}<br/>
              水：{@getElementPercentString("aqua")}<br/>
              风：{@getElementPercentString("wind")}<br/>
            </p>
            <p className="media-info hidden-sm">
              光：{@getElementPercentString("light")}<br/>
              暗：{@getElementPercentString("dark")}<br/>
              DPS：<span id="dps">{@getString("dps")}</span><br/>
              总DPS：<span id="mdps">{@getString("mdps")}</span><br/>
            </p>
          </div>
        </div>
      </a>
    </li>


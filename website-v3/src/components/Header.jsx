'use strict';

var React = require('react/addons');

var ReactRouteHandler = require('react-router').RouteHandler;
//var Actions = require('actions/xxx')

require('styles/Header.scss');

var Header = React.createClass({

  render: function () {
    return (
      <header className="bar bar-nav">

        <div className="input-icon input-search" style={{display: 'none'}}>
          <span className="icon icon-search"></span>
          <input type="search" placeholder="Search"/>
          <a className="icon icon-close pull-right"></a>
        </div>

        <a className="icon icon-bars pull-left"></a>
        <a className="icon icon-search pull-right"></a>

        <ReactRouteHandler partial="HeaderFilters"/>

      </header>
    );
  }
});

export default Header;


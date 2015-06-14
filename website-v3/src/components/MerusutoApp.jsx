'use strict';

var React = require('react/addons');
var ReactRouteHandler = require('react-router').RouteHandler;
var Header = require('./Header');

// CSS
require('ratchet/dist/css/ratchet.css');
require('../styles/mobile.scss');

var imageURL = require('../images/yeoman.png');

var MerusutoApp = React.createClass({
  render: function() {
    return (
      <div className='main'>
        <Header/>
        <div className="content">
          <ReactRouteHandler/>
        </div>
      </div>
    );
  }
});

module.exports = MerusutoApp;

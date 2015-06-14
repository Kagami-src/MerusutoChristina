'use strict';

describe('Header', function () {
  var React = require('react/addons');
  var Header, component;

  beforeEach(function () {
    Header = require('components/Header.jsx');
    component = React.createElement(Header);
  });

  it('should create a new instance of Header', function () {
    expect(component).toBeDefined();
  });
});

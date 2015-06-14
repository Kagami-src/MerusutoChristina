'use strict';

describe('Index', function () {
  var React = require('react/addons');
  var Index, component;

  beforeEach(function () {
    Index = require('components/units/Index.jsx');
    component = React.createElement(Index);
  });

  it('should create a new instance of Index', function () {
    expect(component).toBeDefined();
  });
});

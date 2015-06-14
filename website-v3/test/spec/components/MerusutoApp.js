'use strict';

describe('MerusutoApp', function () {
  var React = require('react/addons');
  var MerusutoApp, component;

  beforeEach(function () {
    var container = document.createElement('div');
    container.id = 'content';
    document.body.appendChild(container);

    MerusutoApp = require('components/MerusutoApp.js');
    component = React.createElement(MerusutoApp);
  });

  it('should create a new instance of MerusutoApp', function () {
    expect(component).toBeDefined();
  });
});

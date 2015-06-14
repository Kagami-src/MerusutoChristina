'use strict';

var MerusutoApp = require('./MerusutoApp');
var React = require('react');
var Router = require('react-router');
var {Route, Redirect} = Router;

var UnitsIndex = require('./units/Index');

var content = document.getElementById('content');

var Routes = (
  <Route handler={MerusutoApp} path="/">
    <Route name="units" handler={UnitsIndex}/>
    <Redirect from="" to="units"/>
  </Route>
);

Router.run(Routes, function (Handler) {
  React.render(<Handler/>, content);
});

#= require views/desktop/pages/units/index

class App.Pages.UnitsCompare extends App.Pages.UnitsIndex
  template: _.loadTemplate("templates/desktop/pages/units/compare")

  renderActions: (data, type, model) =>
    "<a class='glyphicon glyphicon-stats action-compare' " +
      "href='#units/#{@model.id}/compare/#{model.id}' data-toggle='tooltip' " +
      "data-placement='top' title='数据比较'></a>"

  openShowPage: (event) ->
    return if $(event.target).is("a[href]")
    @$target = $(event.currentTarget)
    href = @$target.find(".action-compare").attr("href")
    App.router.navigate(href, true)

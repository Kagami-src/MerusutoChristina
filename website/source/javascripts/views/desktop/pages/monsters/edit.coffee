#= require views/desktop/pages/units/edit

class App.Pages.MonstersEdit extends App.Pages.UnitsEdit
  template: _.loadTemplate("templates/desktop/pages/monsters/edit")

  events: _.extend App.Pages.UnitsEdit::events,
    "click .calculator": "showCalculatorModal"
    "keyup #calculator-modal input[type=number]": "calculateSize"
    "change #calculator-modal input[type=number]": "calculateSize"
    "click #insert-button": "insertForm"

  showCalculatorModal: ->
    @$calculatorModal = @$("#calculator-modal").modal()

  calculateSize: ->
    size = @$("#csize").val()
    life = @$("#clife").val()
    atk = @$("#catk").val()
    @$("#rlife").val(Math.round(life / size))
    @$("#ratk").val(Math.round(atk / Math.pow(size, 2.36)))

  insertForm: (event) ->
    event.preventDefault()

    @$("#life").val(@$("#rlife").val())
    @$("#atk").val(@$("#ratk").val())

    @$calculatorModal.modal("hide")

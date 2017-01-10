App.Surveys =

  hoverize: (surveys) ->
    $(document).on {
      'mouseenter focus': ->
        $("div.not-logged", this).css('display', 'inline-block')
      mouseleave: ->
        $("div.not-logged", this).hide()
    }, surveys

  initialize: ->
    App.Surveys.hoverize "div.survey_banner"
    false


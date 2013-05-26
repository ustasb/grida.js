class MousePos
  constructor: ->
    @onMouseMove = ->

  record: (callback) ->
    @onMouseMove = (e) -> callback(e)
    $DOCUMENT.mousemove(@onMouseMove)

  stopRecording: ->
    $DOCUMENT.unbind('mousemove', @onMouseMove)

class MousePos
  $document = $(document)

  constructor: ->
    @onMouseMove = ->

  record: (callback) ->
    @onMouseMove = (e) -> callback(e)
    $document.mousemove(@onMouseMove)

  stopRecording: ->
    $document.unbind('mousemove', @onMouseMove)

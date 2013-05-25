class Draggable
  _mousePos = new MousePos

  constructor: (el, @grid, @marginx) ->
    @$el = $(el)

    @setCssAbsolute()
    @initEvents()

  setCssAbsolute: ->
    $el = @$el
    position = $el.position()

    $el.css
      position: 'absolute'
      left: position.left
      top: position.top

  initEvents: ->
    $el = @$el

    $(document).mouseup -> _mousePos.stopRecording()

    $el.mousedown (e) =>
      position = $el.position()
      # TODO: rename
      startPosLeft = e.pageX - position.left
      startPosTop = e.pageY - position.top

      if @grid
        grid = @grid
        marginx = @marginx
        gridHalf = grid / 2

        mousemove = (e) ->
          left = e.pageX - startPosLeft
          top =  e.pageY - startPosTop

          snapx = left % grid
          snapy = top % grid

          if snapx >= gridHalf
            left += grid - snapx
          else
            left -= snapx

          if snapy >= gridHalf
            top += grid - snapy
          else
            top -= snapy

          $el.css
            left: marginx + left
            top: marginx + top
      else
        mousemove = (e) ->
          $el.css
            left: e.pageX - startPosLeft
            top: e.pageY - startPosTop

      _mousePos.record(mousemove)

      false  # Prevent selection highlighting.

class Resizable
  _mousePos = new MousePos

  constructor: (el, @grid, @marginx) ->
    @$el = $(el)

    @addHandle()
    @initEvents()

  addHandle: ->
    @$handle = $('<div class="xxx-handle-se"></div>')
    @$el.append(@$handle)

  initEvents: ->
    $el = @$el

    $(document).mouseup -> _mousePos.stopRecording()

    @$handle.mousedown (e) =>
      e.stopPropagation()

      # TODO: rename
      startWidth = e.pageX - $el.width()
      startHeight = e.pageY - $el.height()

      if @grid
        grid = @grid
        marginx = @marginx
        gridHalf = grid / 2

        mousemove = (e) ->
          width = e.pageX - startWidth
          height =  e.pageY - startHeight

          snapx = width % grid
          snapy = height % grid

          if snapx >= gridHalf
            width += grid - snapx
          else
            width -= snapx

          if snapy >= gridHalf
            height += grid - snapy
          else
            height -= snapy

          $el.css
            width: (Math.floor(width / grid) - 1) * marginx + width
            height: (Math.floor(height / grid) - 1) * marginx + height

      else
        mousemove = (e) ->
          $el.css
            width: e.pageX - startWidth
            height: e.pageY - startHeight

      _mousePos.record(mousemove)

      false  # Prevent selection highlighting.

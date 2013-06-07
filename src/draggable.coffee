class Draggable

  @create: (el, grid)->
    if grid
      new SnapDraggable(el, grid)
    else
      new Draggable(el)

  constructor: (el) ->
    @el = $(el).get(0)
    @mousePos = new MousePos

    @setCssAbsolute()
    @initEvents()

  setCssAbsolute: ->
    el = @el
    position = $(el).position()

    el.style.position = 'absolute'
    el.style.left = position.left + 'px'
    el.style.top = position.top + 'px'

  initEvents: ->
    $DOCUMENT.mouseup => @mousePos.stopRecording()

    $(@el).mousedown (event) =>
      @mousePos.record @getMousemoveCB(event.pageX, event.pageY)

      false  # Prevent selection highlighting

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    position = $(el).position()

    startLeft = mousex - position.left
    startTop = mousey - position.top

    (event) ->
      el.style.left = event.pageX - startLeft + 'px'
      el.style.top = event.pageY - startTop + 'px'

class SnapDraggable extends Draggable
  constructor: (el, @grid) ->
    super(el)

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    $el = $(el)
    grid = @grid
    round = Math.round

    position = $el.position()

    startLeft = mousex - position.left
    startTop = mousey - position.top

    oldRowCol = round(grid.topToRowUnit(position.top)) + 'x' +
                round(grid.leftToColUnit(position.left))

    (event) ->
      left = event.pageX - startLeft
      top = event.pageY - startTop

      row = round grid.topToRowUnit(top)
      col = round grid.leftToColUnit(left)

      if (row + 'x' + col) isnt oldRowCol
        $el.trigger('xxx-draggable-snap', [row, col])
        oldRowCol = row + 'x' + col

      el.style.left = left + 'px'
      el.style.top = top + 'px'

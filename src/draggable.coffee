class Draggable

  @create: (el, grid) ->
    if grid
      new SnapDraggable(el, grid)
    else
      new Draggable(el)

  constructor: (el) ->
    @el = $(el).get(0)

    @setCssAbsolute()
    @initEvents()

  setCssAbsolute: ->
    el = @el
    position = $(el).position()

    el.style.position = 'absolute'
    el.style.left = position.left + 'px'
    el.style.top = position.top + 'px'

  initEvents: ->
    $el = $(@el)
    mousemove = null

    $el.mousedown (event) =>
      $el.trigger('xxx-draggable-mousedown', [event])
      mousemove = @getMousemoveCB(event.pageX, event.pageY)
      $DOCUMENT.mousemove(mousemove)

      false  # Prevent selection highlighting

    $el.mouseup (event) =>
      $el.trigger('xxx-draggable-mouseup', [event])
      $DOCUMENT.unbind('mousemove', mousemove)
      mousemove = null

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

    oldColRow = round(grid.leftToCol(position.left)) + 'x' +
                round(grid.topToRow(position.top))

    (event) ->
      left = event.pageX - startLeft
      top = event.pageY - startTop

      col = round grid.leftToCol(left)
      row = round grid.topToRow(top)

      colRow = col + 'x' + row
      if oldColRow isnt colRow
        $el.trigger('xxx-draggable-snap', [col, row])
        oldColRow = colRow

      el.style.left = grid.colToLeft(col) + 'px'
      el.style.top = grid.rowToTop(row) + 'px'

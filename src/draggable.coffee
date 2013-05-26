class Draggable

  @create: (el, opts = {}) ->
    grid = opts.grid
    margin = opts.margin

    if grid
      new SnapDraggable(el, grid.x, grid.y, margin.x, margin.y)
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
  constructor: (el, @gridx, @gridy, @marginx, @marginy) ->
    super(el)

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    marginx = @marginx
    marginy = @marginy
    gridx = @gridx + marginx
    gridy = @gridy + marginy
    gridxHalf = gridx / 2
    gridyHalf = gridy / 2

    position = $(el).position()
    offsetLeft = position.left % gridx
    offsetTop = position.top % gridy

    startLeft = mousex - position.left
    startTop = mousey - position.top

    (event) ->
      left = event.pageX - startLeft
      top = event.pageY - startTop

      snapx = left % gridx
      snapy = top % gridy

      if snapx >= gridxHalf
        left += gridx - snapx
      else
        left -= snapx

      if snapy >= gridyHalf
        top += gridy - snapy
      else
        top -= snapy

      left += offsetLeft
      top += offsetTop

      el.style.left = left + 'px'
      el.style.top =  top + 'px'

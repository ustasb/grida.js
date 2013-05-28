class Resizable

  @create: (el, opts = {}) ->
    grid = opts.grid
    margin = opts.margin

    if grid
      new SnapResizable(el, grid.x, grid.y, margin.x, margin.y)
    else
      new Resizable(el)

  constructor: (el) ->
    @el = $(el).get(0)
    @mousePos = new MousePos

    @addHandle()
    @initEvents()

  addHandle: ->
    $(@el).append('<div class="xxx-handle-se"></div>')

  initEvents: ->
    $DOCUMENT.mouseup => @mousePos.stopRecording()

    $(@el).children('.xxx-handle-se').mousedown (event) =>
      event.stopPropagation()

      @mousePos.record @getMousemoveCB(event.pageX, event.pageY)

      false  # Prevent selection highlighting

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    $el = $(el)

    startLeft = mousex - $el.width()
    startTop = mousey - $el.height()

    (event) ->
      el.style.width = event.pageX - startLeft + 'px'
      el.style.height = event.pageY - startTop + 'px'

class SnapResizable extends Resizable
  constructor: (el, @gridx, @gridy, @marginx, @marginy) ->
    super(el)

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    $el = $(el)
    marginx = @marginx
    marginy = @marginy
    gridx = @gridx
    gridy = @gridy
    gridxHalf = gridx / 2
    gridyHalf = gridy / 2

    startLeft = mousex - $el.width()
    startTop = mousey - $el.height()

    oldSizeCombined = 0

    (event) ->
      width = event.pageX - startLeft
      height = event.pageY - startTop

      snapx = width % gridx
      snapy = height % gridy

      if snapx >= gridxHalf
        width += gridx - snapx
      else
        width -= snapx

      if snapy >= gridyHalf
        height += gridy - snapy
      else
        height -= snapy

      width += (Math.floor(width / gridx) - 1) * marginx
      height += (Math.floor(height / gridy) - 1) * marginy

      if oldSizeCombined isnt width + height
        $el.trigger('xxx-resizable-snap', [width, height])
        oldSizeCombined = width + height

      el.style.width = width + 'px'
      el.style.height = height + 'px'

class Resizable

  constructor: (el) ->
    @el = $(el).get(0)

    @addHandle()
    @initEvents()

  addHandle: ->
    $handle = $('<div class="xxx-handle-se"></div>')
    $handle.css
      position: 'absolute'
      bottom: 0
      right: 0
      width: 25
      height: 25
      backgroundColor: 'blue'

    $(@el).append($handle)

  initEvents: ->
    $el = $(@el)
    $handle = $el.children('.xxx-handle-se')
    oldzIndex = null
    mousemove = null

    $handle.mousedown (event) =>
      event.stopPropagation()

      oldzIndex = $el.css('z-index')
      $el.css('z-index', 99999)

      $el.trigger('xxx-resizable-mousedown', [event])

      mousemove = @getMousemoveCB(event.pageX, event.pageY)
      $DOCUMENT.mousemove(mousemove)

      false  # Prevent selection highlighting

    $WINDOW.mouseup (event) =>
      return null if not mousemove

      $el.css('z-index', oldzIndex)
      $el.trigger('xxx-resizable-mouseup', [event])

      $DOCUMENT.unbind('mousemove', mousemove)
      mousemove = null

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    $el = $(el)

    startLeft = mousex - $el.width()
    startTop = mousey - $el.height()

    (event) ->
      el.style.width = event.pageX - startLeft + 'px'
      el.style.height = event.pageY - startTop + 'px'

class SnapResizable extends Resizable
  constructor: (el, @grid) ->
    super(el)

  getMousemoveCB: (mousex, mousey) ->
    el = @el
    $el = $(el)
    grid = @grid
    round = Math.round

    position = $el.position()

    startLeft = mousex - $el.width()
    startTop = mousey - $el.height()

    oldSize = round(grid.widthToSize($el.width())) + 'x' +
              round(grid.heightToSize($el.height()))

    (event) ->
      width = event.pageX - startLeft
      height = event.pageY - startTop

      sizex = round grid.widthToSize(width)
      sizey = round grid.heightToSize(height)

      sizex = 1 if sizex is 0
      sizey = 1 if sizey is 0

      newSize = sizex + 'x' + sizey
      if newSize isnt oldSize
        $el.trigger('xxx-resizable-snap', [sizex, sizey])
        oldSize = newSize

      el.style.width = width + 'px'
      el.style.height = height + 'px'

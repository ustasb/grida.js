class DOMTile extends Tile

  # Number of tiles created.
  _count = 0

  # Tiles that need their CSS updated.
  _changedTiles = {}

  @updateChangedTiles: ->
    for _, tile of _changedTiles
      tile.updatePos()
      tile.updateSize()

    _changedTiles = {}

  constructor: (@el, @grid, sizex, sizey) ->
    super(sizex, sizey)

    @id = _count++

    el.style.position = 'absolute'

    @makeDraggable()

  makeDraggable: ->
    $el = $(@el)

    $ghost = $('<div class="xxx-draggable-ghost"></div>')
    $ghost.css
      position: 'absolute'
      backgroundColor: 'blue'
      zIndex: -1

    @draggable = new SnapDraggable(@el, @grid)

    $el.on 'xxx-draggable-mousedown', (e) =>
      position = $el.position()
      $ghost.css
        left: position.left
        top: position.top
        width: $el.width()
        height: $el.height()
      .appendTo $el.parent()

    $el.on 'xxx-draggable-mouseup', (e) =>
      position = $ghost.position()
      $el.css
        left: position.left
        top: position.top
      $ghost.remove()

    $el.on 'xxx-draggable-snap', (e, col, row) =>
      col = 0 if col < 0
      row = 0 if row < 0

      maxCol = @grid.maxCol
      if (col + @sizex - 1) > maxCol
        col = maxCol - (@sizex - 1)

      if @grid.attemptInsertAt(@, col, row) is false
        return null

      @grid.sortTilesByPos()

      $ghost.css
        left: @grid.colToLeft(@col)
        top: @grid.rowToTop(@row)

      DOMTile.updateChangedTiles()

    null

  setPosition: (grid, col, row) ->
    super

    _changedTiles[@id] = @
    @draggable.grid = grid

    null

  updateSize: ->
    @el.style.width = @grid.sizeToWidth(@sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(@sizey) + 'px'

    null

  updatePos: ->
    @el.style.left = @grid.colToLeft(@col) + 'px'
    @el.style.top = @grid.rowToTop(@row) + 'px'

    null

class DOMTile extends Tile

  _changedSizes = {}
  _changedPositions = {}

  @updateChangedTiles: ->
    tile.updateSize() for _, tile of _changedSizes
    _changedSizes = {}

    tile.updatePos() for _, tile of _changedPositions
    _changedPositions = {}

  constructor: (@el, @grid, sizex, sizey) ->
    super(sizex, sizey)

    el.style.position = 'absolute'

    @draggable = @makeDraggable()
    @resizable = @makeResizable()

  makeResizable: ->
    $el = $(@el)

    $ghost = $('<div class="xxx-draggable-ghost"></div>')
    $ghost.css
      position: 'absolute'
      backgroundColor: 'blue'
      zIndex: -1

    $el.on 'xxx-resizable-mousedown', (e) =>
      position = $el.position()
      $ghost.css
        left: position.left
        top: position.top
      .appendTo $el.parent()

    $el.on 'xxx-resizable-mouseup', (e) =>
      $el.css
        width: $ghost.width()
        height: $ghost.height()
      $ghost.remove()

    $el.on 'xxx-resizable-snap', (e, sizex, sizey) =>
      maxCol = @grid.maxCol
      if @col + sizex > maxCol
        sizex = (maxCol - @col) + 1

      @grid.collapseNeighborsAfter @, =>
        @setSize(sizex, sizey)
        @grid.insertAt(@, @col, @row)

      $ghost.css
        width: @grid.sizeToWidth(sizex)
        height: @grid.sizeToHeight(sizey)

      DOMTile.updateChangedTiles()

    new SnapResizable(@el, @grid)

  makeDraggable: ->
    $el = $(@el)

    $ghost = $('<div class="xxx-draggable-ghost"></div>')
    $ghost.css
      position: 'absolute'
      backgroundColor: 'blue'
      zIndex: -1

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

    new SnapDraggable(@el, @grid)

  setSize: (sizex, sizey) ->
    super

    _changedSizes[@id] = @

    null

  setPosition: (grid, col, row) ->
    super

    _changedPositions[@id] = @
    @draggable.grid = grid
    @resizable.grid = grid

    null

  updateSize: ->
    @el.style.width = @grid.sizeToWidth(@sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(@sizey) + 'px'

    null

  updatePos: ->
    @el.style.left = @grid.colToLeft(@col) + 'px'
    @el.style.top = @grid.rowToTop(@row) + 'px'

    null

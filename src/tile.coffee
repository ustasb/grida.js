class Tile

  constructor: (@sizex = 1, @sizey = 1) ->
    if sizex < 0 or sizey < 0
      throw new RangeError('A size cannot be negative.')

    @col = null
    @row = null

  setPosition: (grid, col, row) ->
    @releasePosition()

    @grid = grid
    @col = col
    @row = row

    @grid.addTile(@, col, row)

    null

  releasePosition: ->
    return null if not @isInGrid()

    @grid.removeTile(@)

    @grid = null
    @col = null
    @row = null

    null

  isInGrid: ->
    @grid? and @col? and @row?

class HTMLTile extends Tile

  count = 0
  changedTiles = {}

  @updateChangedTiles: ->
    for _, tile of changedTiles
      tile.updatePos()
      tile.updateSize()
    changedTiles = {}

  constructor: (@el, sizex, sizey) ->
    super(sizex, sizey)

    @id = count++

    el.style.position = 'absolute'

    @makeDraggable()

  makeDraggable: ->
    $el = $(@el)

    @draggable = new SnapDraggable(@el)

    $el.on 'xxx-draggable-mousedown', (e) =>

    $el.on 'xxx-draggable-mouseup', (e) =>

    $el.on 'xxx-draggable-snap', (e, col, row) =>
      @grid.insertAt(@, col, row)
      HTMLTile.updateChangedTiles()


  setPosition: (grid, col, row) ->
    super
    @draggable.grid = grid
    changedTiles[@id] = @
    null

  updateSize: ->
    @el.style.width = @grid.sizeToWidth(@sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(@sizey) + 'px'
    null

  updatePos: ->
    @el.style.left = @grid.colToLeft(@col) + 'px'
    @el.style.top = @grid.rowToTop(@row) + 'px'
    null

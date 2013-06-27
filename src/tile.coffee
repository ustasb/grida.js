class Tile

  _count = 0

  constructor: (sizex = 1, sizey = 1) ->
    @id = _count++

    @setSize(sizex, sizey)
    @grid = null
    @col = null
    @row = null

  setSize: (sizex, sizey) ->
    if sizex < 0 or sizey < 0
      throw new RangeError('A size cannot be negative.')

    @sizex = sizex
    @sizey = sizey

  setPosition: (grid, col, row) ->
    @releasePosition()

    @grid = grid
    @col = col
    @row = row

    null

  releasePosition: ->
    @grid.removeTile(@) if @grid?

    @grid = null
    @col = null
    @row = null

    null

class Tile

  _count = 0

  constructor: (sizex = 1, sizey = 1) ->
    @id = _count++

    @updatePos()
    @updateSize(sizex, sizey)

  updatePos: (@grid, @col, @row) ->
    @grid = @col = @row = null if not grid?

  updateSize: (sizex, sizey) ->
    if sizex < 0 or sizey < 0
      throw new RangeError('A size cannot be negative.')

    @sizex = sizex
    @sizey = sizey

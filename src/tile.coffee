class Tile

  _count = 0

  constructor: (sizex = 1, sizey = 1) ->
    @id = _count++

    @grid = @col = @row = null

    @updateSize(sizex, sizey)

  updatePos: (@grid, @col, @row) ->

  updateSize: (sizex, sizey) ->
    if sizex <= 0 or sizey <= 0
      throw new RangeError('A size must be > 0')

    @sizex = sizex
    @sizey = sizey

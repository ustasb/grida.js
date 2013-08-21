class Tile

  _count = 0

  constructor: (sizex = 1, sizey = 1) ->
    @id = ++_count

    @setPos(null)
    @setSize(sizex, sizey)

  setPos: (@grid = null, col, row) ->
    if @grid is null
      @col = @row = null
    else
      @col = col
      @row = row

    null

  setSize: (sizex, sizey) ->
    if sizex <= 0 or sizey <= 0
      throw new RangeError('A size must be > 0')

    @sizex = sizex
    @sizey = sizey

    null

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

    grid.set(@, col, row, @sizex, @sizey)

    null

  releasePosition: ->
    return null if not @isInGrid()

    @grid.clear(@col, @row, @sizex, @sizey, @)

    @grid = null
    @col = null
    @row = null

    null

  isInGrid: ->
    @grid? and @col? and @row?

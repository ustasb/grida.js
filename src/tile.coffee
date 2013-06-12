class Tile

  constructor: (@sizex = 1, @sizey = 1) ->
    @col = null
    @row = null

  setPosition: (@grid, @col, @row) ->
    grid.set(@, col, row, @sizex, @sizey)

    null

  releasePosition: ->
    if @isInGrid()
      @grid.clear(@col, @row, @sizex, @sizey)
      @col = null
      @row = null

    null

  isInGrid: ->
    @grid? and @col? and @row?

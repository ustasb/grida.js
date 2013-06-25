# Represents a tile which can exist in multiple grids.
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

    @grid.setTile(@, col, row)

    null

  releasePosition: ->
    if @isInGrid() is false
      return null

    @grid.removeTile(@)

    @grid = null
    @col = null
    @row = null

    null

  isInGrid: ->
    @grid? and @col? and @row?

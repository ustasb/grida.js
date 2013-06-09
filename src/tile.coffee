class Tile

  constructor: (@grid, @sizex = 1, @sizey = 1) ->

    @col = null
    @row = null

  moveTo: (col, row) ->

    @col = col
    @row = row

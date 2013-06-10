class Tile

  id = 0

  constructor: (@grid, @sizex = 1, @sizey = 1) ->
    @id = id++

    @col = null
    @row = null

  moveTo: (@col, @row) ->
    console.log(@id)

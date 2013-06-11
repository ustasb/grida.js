class Tile

  id = 0

  constructor: (@grid, @sizex = 1, @sizey = 1) ->
    @id = id++

    @col = null
    @row = null

  hasPosition: ->
    @col isnt null and @row isnt null

  moveTo: (@col, @row) ->
    #console.log(@id)

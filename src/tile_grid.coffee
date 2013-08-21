# Represents a grid composed of Tile instances.
class TileGrid

  constructor: ->
    @_matrix = new Matrix2D
    @_tiles = {}

  # Sets a tile at a grid area and updates the tile.
  # @return [null]
  _set: (tile, newCol, newRow) ->
    @_matrix.set(tile, newCol, newRow, tile.sizex, tile.sizey)
    @_tiles[tile.id] = tile
    tile.setPos(@, newCol, newRow)

  # Removes a tile from the grid and updates the tile.
  # @return [null]
  remove: (tile) ->
    @_matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)
    delete @_tiles[tile.id]
    tile.setPos(null)

  # Sets a tile at a position and shifts down all obstructing tiles recursively.
  # @return [null]
  insert: (tile, newCol, newRow) ->
    @_matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)

    # Tiles are in row-order (smaller rows first).
    obstructingTiles = @_matrix.get(newCol, newRow, tile.sizex, tile.sizey)

    for oTile in obstructingTiles by 1
      dy = (newRow + tile.sizey) - oTile.row
      @insert(oTile, oTile.col, oTile.row + 1) while --dy >= 0

    @_set(tile, newCol, newRow)

    null

  # Moves a tile upward until an obstacle is reached.
  # @return [Boolean]
  floatUp: (tile) ->
    newRow = tile.row

    while newRow > 0 and
          @_matrix.get(tile.col, newRow - 1, tile.sizex, 1).length is 0
      newRow -= 1

    if newRow is tile.row
      false
    else
      @_matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)
      @_set(tile, tile.col, newRow)
      true

  # @return [Array]
  aboveNeighbors: (tile) ->
    @_matrix.get(tile.col, tile.row - 1, tile.sizex, 1)

  # @return [Array]
  belowNeighbors: (tile) ->
    @_matrix.get(tile.col, tile.row + 1, tile.sizex, 1)

###
  setTile: (tile, col, row) ->
    tile.setPosition(@, col, row)

    @tiles.push(tile)

    @grid.set(tile, col, row, tile.sizex, tile.sizey)

    null

  removeTile: (tile) ->
    index = $.inArray(tile, @tiles)

    if index isnt -1
      @grid.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)
      @tiles.splice(index, 1)

    null

  sortTilesByPos: ->
    @tiles.sort (a, b) ->
      return -1 if a.row < b.row
      return -1 if a.row is b.row and a.col < b.col
      return 1

    null

  # Inserts the tile at a position and shifts down any obstructing tiles.
  # @param focusTile [Tile]
  # @param col, row [whole number]
  # @return [null]
  insertAt: (focusTile, col, row) ->
    # Tiles are in row-order (smaller rows first).
    obstructingTiles = @grid.get(col, row, focusTile.sizex, focusTile.sizey)

    for tile in obstructingTiles by -1
      continue if tile is focusTile
      dy = (row + focusTile.sizey) - tile.row
      @insertAt(tile, tile.col, tile.row + 1) while --dy >= 0

    @setTile(focusTile, col, row)

    null

  # Finds the lowest above row that the tile could shift up to.
  # @param tile [Tile]
  # @param col, row [whole number]
  # @return [integer]
  getLowestAboveRow: (tile, col = tile.col, row = tile.row) ->
    @validateTile(tile)

    lowestRow = row
    sizex = tile.sizex

    while lowestRow > 0 and @grid.get(col, lowestRow - 1, sizex, 1).length is 0
      lowestRow -= 1

    lowestRow

  # Moves the tile upwards until it encounters a barrier.
  # @param tile [Tile]
  # @return [null]
  collapseAboveEmptySpace: (tile) ->
    @validateTile(tile)

    newRow = @getLowestAboveRow(tile)

    if newRow isnt tile.row
      @setTile(tile, tile.col, newRow)

    null

  # Calls the callback and recursively shifts all old below neighbors up.
  # @param tile [Tile]
  # @param callback [function]
  # @return [null]
  collapseNeighborsAfter: (tile, callback) ->
    @validateTile(tile)

    belowNeighbors = @grid.get(tile.col, tile.row + tile.sizey, tile.sizex, 1)

    callback() if callback?

    for neighbor in belowNeighbors by 1
      @collapseNeighborsAfter neighbor, =>
        @collapseAboveEmptySpace(neighbor)

    null

  # Tries to insert a tile at a location while maintaining the invariant:
  #
  #   Each tile must have an above neighbor tile except for tiles in row 0.
  #
  # @param focusTile [Tile]
  # @param col, row [whole number]
  # @return [boolean] success status
  attemptInsertAt: (focusTile, col, row) ->
    if row is 0
      @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
      return true

    @grid.clear(focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey)
    obstructingTiles = @grid.get(col, row, focusTile.sizex, focusTile.sizey)

    if row > focusTile.row
      for oTile in obstructingTiles by 1
        if focusTile.row + oTile.sizey is row and @getLowestAboveRow(oTile) is focusTile.row
          @collapseNeighborsAfter oTile, => @setTile(oTile, oTile.col, focusTile.row)
          swapOccured = true

      if swapOccured
        @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
        return true

    aboveTiles = @grid.get(col, row - 1, focusTile.sizex, 1)

    if aboveTiles.length is 0 and obstructingTiles.length is 0
      newRow = @getLowestAboveRow(focusTile, col, row)
      @collapseNeighborsAfter focusTile, => @setTile(focusTile, col, newRow)
      return true

    for tile in aboveTiles by 1
      if tile.row + tile.sizey is row
        @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
        return true

    for tile in obstructingTiles by 1
      lowestRow = @getLowestAboveRow(tile)
      if lowestRow + tile.sizey is row
        @collapseNeighborsAfter tile, =>
          @setTile(tile, tile.col, lowestRow)
          @insertAt(focusTile, col, row)
        return true

    @grid.set(focusTile, focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey)

    false
###

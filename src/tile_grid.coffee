# Represents a grid composed of Tile instances.
class TileGrid extends Grid

  constructor: ->
    super

    @tiles = []

  setTile: (tile, col, row) ->
    @set(tile, col, row, tile.sizex, tile.sizey)

    index = $.inArray(tile, @tiles)
    @tiles.push(tile) if index is -1

    null

  removeTile: (tile) ->
    @clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)

    index = $.inArray(tile, @tiles)
    @tiles.splice(index, 1) if index isnt -1

    null

  sortTilesByPos: ->
    @tiles.sort (a, b) ->
      return -1 if a.row < b.row
      return -1 if a.row is b.row and a.col < b.col
      return 1

    null

  # Finds the lowest above row that the tile could shift up to.
  # @param focusTile [Tile]
  # @param col, row [whole number]
  # @return [integer]
  getLowestAboveRow: (focusTile, col = focusTile.col, row = focusTile.row) ->
    lowestRow = row
    sizex = focusTile.sizex

    while lowestRow > 0 and @get(col, lowestRow - 1, sizex, 1).length is 0
      lowestRow -= 1

    lowestRow

  # Inserts the tile at a position and shifts down any obstructing tiles.
  # @param focusTile [Tile]
  # @param col, row [whole number]
  # @return [null]
  insertAt: (focusTile, col, row) ->
    focusTile.releasePosition()

    # Tiles are in row-order (smaller rows first).
    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

    for tile in obstructingTiles by -1
      dy = (row + focusTile.sizey) - tile.row
      @insertAt(tile, tile.col, tile.row + 1) while --dy >= 0

    focusTile.setPosition(@, col, row)

    null

  # Moves the tile upwards until it encounters a barrier.
  # @param focusTile [Tile]
  # @return [null]
  collapseAboveEmptySpace: (focusTile) ->
    if focusTile.isInGrid() is false or focusTile.row is 0
      return null

    newRow = @getLowestAboveRow(focusTile)

    if newRow isnt focusTile.row
      focusTile.setPosition(@, focusTile.col, newRow)

    null

  # Calls the callback and recursively shifts all old below neighbors up.
  # @param tile [Tile]
  # @param callback [function]
  # @return [null]
  collapseNeighborsAfter: (tile, callback) ->
    belowNeighbors = @get(tile.col, tile.row + tile.sizey, tile.sizex, 1)

    callback() if callback?

    for neighbor in belowNeighbors by 1
      @collapseNeighborsAfter neighbor, =>
        @collapseAboveEmptySpace(neighbor)

    null

  # Attempts to swap a tile with the tiles at the specified position.
  # @param focusTile [Tile]
  # @param col, row [whole number]
  # @return [boolean] success status
  swapIfPossible: (focusTile, col, row) ->
    return false if row is focusTile.row

    swapOccured = false

    @removeTile(focusTile)
    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

    if row > focusTile.row
      for tile in obstructingTiles by 1
        newRow = @getLowestAboveRow(tile)

        if newRow + tile.sizey is row
          swapOccured = true
          @collapseNeighborsAfter tile, =>
            @insertAt(tile, tile.col, newRow)

    else
      dy = focusTile.row - row

      for tile in obstructingTiles by 1
        if tile.sizey is dy and @getLowestAboveRow(tile, col, row) is row
          swapOccured = true
          break

    if swapOccured
      @collapseNeighborsAfter focusTile, =>
        @insertAt(focusTile, col, row)
    else
      @setTile(focusTile, focusTile.col, focusTile.row)

    swapOccured

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

    if @swapIfPossible(focusTile, col, row)
      return true

    @removeTile(focusTile)
    aboveTiles = @get(col, row - 1, focusTile.sizex, 1)

    if aboveTiles.length is 0
      obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

      if obstructingTiles.length is 0
        newRow = @getLowestAboveRow(focusTile, col, row)
        @collapseNeighborsAfter focusTile, => focusTile.setPosition(@, col, newRow)
        return true

    else
      for tile in aboveTiles by 1
        if tile.row + tile.sizey is row
          @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
          return true

    @setTile(focusTile, focusTile.col, focusTile.row)
    false

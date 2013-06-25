class TileGrid extends Grid

  constructor: ->
    super

  setTile: (tile, col, row) ->
    @set(tile, col, row, tile.sizex, tile.sizey)
    null

  removeTile: (tile) ->
    @clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)
    null

  # Inserts a tile at a position and shifts down any obstructing tiles.
  # @param focusTile [Tile] the tile to move
  # @param col, row [whole number]
  # @return [null]
  insertAt: (focusTile, col, row) ->
    focusTile.releasePosition()

    # Tiles are in row order (smaller rows first).
    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

    for tile in obstructingTiles by -1
      dy = (row + focusTile.sizey) - tile.row
      @insertAt(tile, tile.col, tile.row + 1) while --dy >= 0

    focusTile.setPosition(@, col, row)

    null

  getLowestAboveRow: (focusTile, col = focusTile.col, row = focusTile.row) ->
    lowestRow = row
    sizex = focusTile.sizex

    while lowestRow > 0 and @get(col, lowestRow - 1, sizex, 1).length is 0
      lowestRow -= 1

    lowestRow

  # Moves a tile upwards until it encounters another tile or the grid's edge.
  # @param focusTile [Tile] the tile to move
  # @param recursive [boolean] if true, also move up below neighboring tiles
  # @return [null]
  collapseAboveEmptySpace: (focusTile) ->
    if focusTile.isInGrid() is false or focusTile.row is 0
      return null

    newRow = @getLowestAboveRow(focusTile)

    if newRow isnt focusTile.row
      focusTile.setPosition(@, focusTile.col, newRow)

    null

  collapseNeighborsAfter: (focusTile, callback) ->
    belowNeighbors = @get(focusTile.col, focusTile.row + focusTile.sizey, focusTile.sizex, 1)

    callback() if callback?

    for neighbor in belowNeighbors by 1
      @collapseNeighborsAfter neighbor, =>
        @collapseAboveEmptySpace(neighbor)

    null

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

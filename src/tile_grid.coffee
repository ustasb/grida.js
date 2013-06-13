class TileGrid extends Grid

  @POS_TRADE_TYPES:
    NONE: 0
    NEIGHBOR_HORIZONTAL: 1
    NEIGHBOR_VERTICAL: 2
    NEIGHBOR_HORIZONTAL_VERTICAL: 3
    NEIGHBOR_ALL: 4
    HORIZONTAL: 5
    VERTICAL: 6
    HORIZONTAL_VERTICAL: 7
    ALL: 8

  constructor: (tilex, tiley, marginx, marginy) ->
    super()

    @tilex = -> tilex
    @tiley = -> tiley
    @marginx = -> marginx
    @marginy = -> marginy

    # Converts a column unit to a CSS left position.
    @colToLeft = (col) ->
      marginx + col * (tilex + marginx)

    # Converts a CSS left position to a column unit.
    @leftToCol = (left) ->
      (left - marginx) / (tilex + marginx)

    # Converts a row unit to a CSS top position.
    @rowToTop = (row) ->
      marginy + row * (tiley + marginy)

    # Converts a CSS top position to a row unit.
    @topToRow = (top) ->
      (top - marginy) / (tiley + marginy)

    # Converts a grid sizex to a pixel width.
    @sizeToWidth = (size) ->
      if size <= 0
        return 0 if size is 0
        throw 'A size cannot be negative.'
      else
        size * (tilex + marginx) - marginx

    # Converts a pixel width to a grid sizex.
    @widthToSize = (width) ->
      if width <= 0
        return 0 if width is 0
        throw 'A width cannot be negative.'
      else
        (width + marginx) / (tilex + marginx)

    # Converts a grid sizey to a pixel height.
    @sizeToHeight = (size) ->
      if size <= 0
        return 0 if size is 0
        throw 'A size cannot be negative.'
      else
        size * (tiley + marginy) - marginy

    # Converts a pixel height to a grid sizey.
    @heightToSize = (height) ->
      if height <= 0
        return 0 if height is 0
        throw 'A height cannot be negative.'
      else
        (height + marginy) / (tiley + marginy)

  # Inserts a tile at a position and shifts down any obstructing tiles.
  # @param focusTile [Tile] the tile to move
  # @param col, row [whole number]
  # @return [null]
  insertAt: (focusTile, col, row) ->
    focusTile.releasePosition()

    # Tiles are in row order (smaller rows first).
    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

    for tile in obstructingTiles by -1
      @clear(tile.col, tile.row, tile.sizex, tile.sizey)
      dy = (row + focusTile.sizey) - tile.row
      @insertAt(tile, tile.col, tile.row + dy)

    focusTile.setPosition(@, col, row)

    null

  # Moves a tile upwards until it encounters another tile or the grid's edge.
  # @param focusTile [Tile] the tile to move
  # @param targetRow [whole number] the destination row
  # @return [null]
  collapseAboveEmptySpace: (focusTile, targetRow = 0) ->
    if targetRow < 0
      throw new RangeError('targetRow cannot be less than 0.')

    if focusTile.isInGrid() is false or targetRow >= focusTile.row
      return null

    # Tiles are in row order (smaller rows first).
    aboveTiles = @get(focusTile.col, targetRow, focusTile.sizex, focusTile.row - targetRow)

    newRow = targetRow
    for tile in aboveTiles by -1
      neighborRow = tile.row + tile.sizey
      if neighborRow > newRow
        newRow = neighborRow

    if newRow isnt focusTile.row
      col = focusTile.col
      focusTile.releasePosition()
      focusTile.setPosition(@, col, newRow)

    null

  swapWithTilesAt: do ->

    canSwap = (grid, focusTile, col, row, testInverse = true) ->
      tilesToSwap = grid.get(col, row, focusTile.sizex, focusTile.sizey)

      index = $.inArray(focusTile, tilesToSwap)
      if index isnt -1
        if tilesToSwap.length > 1
          # The focus tile is in the way.
          return false
        else
          tilesToSwap.splice(index, 1)

      for tile in tilesToSwap
        if tile.col < col or tile.row < row or
           tile.col + tile.sizex > col + focusTile.sizex or
           tile.row + tile.sizey > row + focusTile.sizey

          if testInverse is false
            return false
          else
            c = focusTile.col - (col - tile.col)
            r = focusTile.row - (row - tile.row)
            if c < 0 or r < 0 or canSwap(grid, tile, c, r, false) is false
              return false

      tilesToSwap

    (focusTile, col, row) ->

      if focusTile.col is col and focusTile.row is row
        return false

      tilesToSwap = canSwap(@, focusTile, col, row)

      if tilesToSwap is false
        return false
      else
        fc = focusTile.col
        fr = focusTile.row
        focusTile.releasePosition()

        for tile in tilesToSwap
          tc = tile.col
          tr = tile.row
          tile.releasePosition()
          tile.setPosition(@, fc - (col - tc), fr - (row - tr))

        focusTile.setPosition(@, col, row)

        true


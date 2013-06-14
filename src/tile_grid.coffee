class TileGrid extends Grid

  InsertType =
    COLLAPSE_UP: 1
    SHIFT_DOWN: 1
    SHIFT_DOWN: 1

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

  constructor: ->
    super

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
      newRow = neighborRow if neighborRow > newRow

    if newRow isnt focusTile.row
      focusTile.setPosition(@, focusTile.col, newRow)

    null

  # Tries to swap a tile's position with obstructing tiles at a given position.
  # @param focusTile [Tile] the tile to move
  # @param col, row [whole number] target position
  # @return [boolean] true if a swap occurred
  swapWithTilesAt: do ->

    # Tests if the tile can swap positions with the obstructing tiles.
    # It returns the obstructing tiles if a swap is possible.
    # @param grid [Grid]
    # @param focusTile [Tile]
    # @param col, row [whole number]
    # @param testInverse [boolean] Test if the obstructing tiles can swap with
    #                              the focus tile.
    # @return [Array or false]
    canSwap = (grid, focusTile, col, row, testInverse = true) ->
      obstructingTiles = grid.get(col, row, focusTile.sizex, focusTile.sizey)

      index = $.inArray(focusTile, obstructingTiles)
      if index isnt -1
        if obstructingTiles.length > 1
          return false  # The focus tile is in the way.
        obstructingTiles.splice(index, 1)

      for tile in obstructingTiles
        if tile.col < col or tile.row < row or
           tile.col + tile.sizex > col + focusTile.sizex or
           tile.row + tile.sizey > row + focusTile.sizey

          return false if testInverse is false

          newCol = focusTile.col - (col - tile.col)
          newRow = focusTile.row - (row - tile.row)

          return false if newCol < 0 or newRow < 0 or
                          canSwap(grid, tile, newCol, newRow, false) is false

      obstructingTiles

    (focusTile, col, row) ->
      if focusTile.col is col and focusTile.row is row
        return false

      tilesToSwap = canSwap(@, focusTile, col, row)

      if tilesToSwap is false
        return false

      for tile in tilesToSwap
        newCol = focusTile.col - (col - tile.col)
        newRow = focusTile.row - (row - tile.row)
        tile.setPosition(@, newCol, newRow)

      focusTile.setPosition(@, col, row)

      true

  attemptInsertAt: (focusTile, col, row) ->
    if col < 0 or row < 0
      return false

    if row is 0
      @insertAt(focusTile, col, row)
      return true

    if @swapWithTilesAt(focusTile, col, row) is true
      @collapseAboveEmptySpace(focusTile)
      return true

    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)
    for tile in obstructingTiles
      if tile.row is row
        @insertAt(focusTile, col, row)
        return true

    false

class HTMLTileGrid extends TileGrid

  constructor: (@$container, tilex, tiley, marginx, marginy) ->
    super

    @initConversionUtils(tilex, tiley, marginx, marginy)

    #calcMaxCol = =>
      #width = $container.width() - (2 * marginx)
      #Math.floor(@widthToSize(width)) - 1
    #@maxCol = calcMaxCol()

    #calcCenteringOffset = =>
      #($container.width() - @sizeToWidth(@maxCol + 1) - (2 * marginx)) / 2
    #@centeringOffset = 0

    #$WINDOW.resize =>
      #@maxCol = calcMaxCol()
      #@centeringOffset = calcCenteringOffset()

  initConversionUtils: (tilex, tiley, marginx, marginy) ->

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
        throw new RangeError('A size cannot be negative.')

      size * (tilex + marginx) - marginx

    # Converts a pixel width to a grid sizex.
    @widthToSize = (width) ->
      if width <= 0
        return 0 if width is 0
        throw new RangeError('A width cannot be negative.')

      (width + marginx) / (tilex + marginx)

    # Converts a grid sizey to a pixel height.
    @sizeToHeight = (size) ->
      if size <= 0
        return 0 if size is 0
        throw new RangeError('A size cannot be negative.')

      size * (tiley + marginy) - marginy

    # Converts a pixel height to a grid sizey.
    @heightToSize = (height) ->
      if height <= 0
        return 0 if height is 0
        throw new RangeError('A height cannot be negative.')

      (height + marginy) / (tiley + marginy)

  appendAtFreeSpace: (focusTile, col = 0, row = 0) ->
    sizex = focusTile.sizex
    sizey = focusTile.sizey
    spaceIsFree = @get(col, row, sizex, sizey).length is 0
    memberMaxCol = col + (sizex - 1)

    if memberMaxCol > @maxCol
      if sizex > (@maxCol + 1) and spaceIsFree
        @insertAt(focusTile, col, row)
      else
        @appendAtFreeSpace(focusTile, 0, row + 1)
    else if spaceIsFree
      @insertAt(focusTile, col, row)
    else
      @appendAtFreeSpace(focusTile, col + 1, row)

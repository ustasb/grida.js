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

  getLowestAboveRow: (focusTile, newCol, newRow) ->
    col = newCol or focusTile.col
    lowestRow = newRow or focusTile.row
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
        if tile.sizey is dy
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
      newRow = @getLowestAboveRow(focusTile, col, row)
      @collapseNeighborsAfter focusTile, => focusTile.setPosition(@, col, newRow)
      return true

    for tile in aboveTiles by 1
      if tile.row + tile.sizey is row
        @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
        return true

    @setTile(focusTile, focusTile.col, focusTile.row)
    false

class HTMLTileGrid extends TileGrid

  constructor: (@$container, @tilex, @tiley, @marginx, @marginy) ->
    super

    @initConversionUtils(tilex, tiley, marginx, marginy)

    @tiles = []
    @maxCol = @getMaxCol()
    @centeringOffset = @getCenteringOffset()

    @initEvents()

  initEvents: ->
    $WINDOW.resize =>
      @maxCol = @getMaxCol()
      @centeringOffset = @getCenteringOffset(@maxCol)

      @grid = []

      for tile in @tiles.slice(0)
        @appendAtFreeSpace(tile)

      HTMLTile.updateChangedTiles()

  getMaxCol: ->
    width = @$container.width() - (2 * @marginx)
    return 0 if width < @tilex
    maxCol = Math.floor(@widthToSize(width)) - 1
    return maxCol

  getCenteringOffset: (maxCol = @getMaxCol()) ->
    width = @sizeToWidth(maxCol + 1) + (2 * @marginx)
    offset = (@$container.width() - width) / 2
    return 0 if offset < 0
    return offset

  initConversionUtils: (tilex, tiley, marginx, marginy) ->

    # Converts a column unit to a CSS left position.
    @colToLeft = (col) ->
      @centeringOffset + marginx + col * (tilex + marginx)

    # Converts a CSS left position to a column unit.
    @leftToCol = (left) ->
      (left - marginx - @centeringOffset) / (tilex + marginx)

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

  setTile: (focusTile, col, row) ->
    super

    index = $.inArray(focusTile, @tiles)
    @tiles.push(focusTile) if index is -1

    null

  removeTile: (focusTile) ->
    super

    index = $.inArray(focusTile, @tiles)
    @tiles.splice(index, 1) if index isnt -1

    null

  sortTilesByPos: ->
    @tiles.sort (a, b) ->
      return -1 if a.row < b.row
      return -1 if a.row is b.row and a.col < b.col
      return 1

    null

  appendAtFreeSpace: (focusTile, col = 0, row = 0) ->
    sizex = focusTile.sizex
    sizey = focusTile.sizey
    isSpaceEmpty = @get(col, row, sizex, sizey).length is 0
    memberMaxCol = col + (sizex - 1)

    if memberMaxCol > @maxCol
      if sizex > (@maxCol + 1) and isSpaceEmpty
        @insertAt(focusTile, col, row)
      else
        @appendAtFreeSpace(focusTile, 0, row + 1)
    else if isSpaceEmpty
      @insertAt(focusTile, col, row)
    else
      @appendAtFreeSpace(focusTile, col + 1, row)

    null

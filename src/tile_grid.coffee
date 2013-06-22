Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

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
      @insertAt(tile, tile.col, tile.row + dy)

    focusTile.setPosition(@, col, row)

    null

  # Moves a tile upwards until it encounters another tile or the grid's edge.
  # @param focusTile [Tile] the tile to move
  # @param recursive [boolean] if true, also move up below neighboring tiles
  # @return [null]
  collapseAboveEmptySpace: (focusTile, recursive = false) ->
    if focusTile.isInGrid() is false or focusTile.row is 0
      return null

    grid = @grid
    newRow = 0
    row = focusTile.row
    i = 0

    while row >= 0
      mod = i % focusTile.sizex
      row -= 1 if mod is 0

      if grid[row]?[focusTile.col + mod]?
        newRow = row + 1
        break

      i += 1

    if newRow isnt focusTile.row
      if recursive is false
        focusTile.setPosition(@, focusTile.col, newRow)
      else
        belowNeighbors = @get(focusTile.col, focusTile.row + focusTile.sizey,
                              focusTile.sizex, 1)

        focusTile.setPosition(@, focusTile.col, newRow)

        for neighbor in belowNeighbors by 1
          @collapseAboveEmptySpace(neighbor, true)

    null

  swapIfPossible: (focusTile, col, row, callback = ->) ->
    dy = focusTile.row - row
    swapDisp = focusTile.sizey * (if dy < 0 then -1 else 1)
    swapOccured = false

    obstructingTiles = @get(col, row, focusTile.sizex, focusTile.sizey)

    for tile in obstructingTiles by 1
      continue if tile is focusTile

      if tile.sizey is Math.abs(dy)
        newRow = tile.row + swapDisp

        otiles = @get(tile.col, newRow, tile.sizex, Math.abs(newRow - tile.row))
        otiles.remove(focusTile)

        if otiles.length is 0
          @doAndCollapseBelowNeigbors tile, => tile.setPosition(@, tile.col, newRow)
          swapOccured = true

    if swapOccured
      @doAndCollapseBelowNeigbors focusTile, => @insertAt(focusTile, col, row)

    swapOccured

  doAndCollapseBelowNeigbors: (focusTile, callback) ->
    belowNeighbors = @get(focusTile.col, focusTile.row + focusTile.sizey, focusTile.sizex, 1)

    callback()

    for neighbor in belowNeighbors
      @collapseAboveEmptySpace(neighbor, true)

  attemptInsertAt: (focusTile, col, row) ->
    if @swapIfPossible(focusTile, col, row)
      return true

    aboveTiles = @get(col, row - 1, focusTile.sizex, 1)
    if aboveTiles.length is 0

      @doAndCollapseBelowNeigbors focusTile, =>
        @insertAt(focusTile, col, row)
        @collapseAboveEmptySpace(focusTile, true)
      return true

    else if aboveTiles.length is 1 and aboveTiles[0] is focusTile
      return false

    else
      for tile in aboveTiles
        if tile.row + tile.sizey is row
          @doAndCollapseBelowNeigbors focusTile, =>
            @insertAt(focusTile, col, row)
          return true

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

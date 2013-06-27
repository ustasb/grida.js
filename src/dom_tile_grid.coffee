class DOMTileGrid extends TileGrid

  constructor: (@$container, @tilex, @tiley, @marginx, @marginy) ->
    super

    @maxCol = @getMaxCol()
    @centeringOffset = @getCenteringOffset()

    @initEvents()

  initEvents: ->
    $WINDOW.resize =>
      @maxCol = @getMaxCol()
      @centeringOffset = @getCenteringOffset(@maxCol)

      @grid.grid = []
      @appendAtFreeSpace(tile) for tile in @tiles.slice(0)
      DOMTile.updateChangedTiles()

  # Converts a column unit to a CSS left position.
  colToLeft: (col) ->
    @centeringOffset + @marginx + col * (@tilex + @marginx)

  # Converts a CSS left position to a column unit.
  leftToCol: (left) ->
    (left - @marginx - @centeringOffset) / (@tilex + @marginx)

  # Converts a row unit to a CSS top position.
  rowToTop: (row) ->
    @marginy + row * (@tiley + @marginy)

  # Converts a CSS top position to a row unit.
  topToRow: (top) ->
    (top - @marginy) / (@tiley + @marginy)

  # Converts a grid sizex to a pixel width.
  sizeToWidth: (size) ->
    if size <= 0
      return 0 if size is 0
      throw new RangeError('A size cannot be negative.')

    size * (@tilex + @marginx) - @marginx

  # Converts a pixel width to a grid sizex.
  widthToSize: (width) ->
    if width <= 0
      return 0 if width is 0
      throw new RangeError('A width cannot be negative.')

    (width + @marginx) / (@tilex + @marginx)

  # Converts a grid sizey to a pixel height.
  sizeToHeight: (size) ->
    if size <= 0
      return 0 if size is 0
      throw new RangeError('A size cannot be negative.')

    size * (@tiley + @marginy) - @marginy

  # Converts a pixel height to a grid sizey.
  heightToSize: (height) ->
    if height <= 0
      return 0 if height is 0
      throw new RangeError('A height cannot be negative.')

    (height + @marginy) / (@tiley + @marginy)

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

  appendAtFreeSpace: (focusTile, col = 0, row = 0) ->
    sizex = focusTile.sizex
    sizey = focusTile.sizey
    isSpaceEmpty = @grid.get(col, row, sizex, sizey).length is 0
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

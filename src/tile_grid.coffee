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

    # Accessors
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

  insertAt: (tile, col, row, tradeType = TileGrid.POS_TRADE_TYPES.NEIGHBOR_VERTICAL) ->

    @set(tile, col, row, tile.sizex, tile.sizey)

    null


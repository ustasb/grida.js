# Represents a 2D grid.
# The origin is at the top left corner.
class Grid

  constructor: (gridx, gridy, marginx, marginy) ->

    # 2D array of members
    @grid = [ [] ]

    # Accessors
    @gridx = -> gridx
    @gridy = -> gridy
    @marginx = -> marginx
    @marginy = -> marginy

    # Converts a column unit to a CSS left position.
    @colToLeft = (col) ->
      marginx + col * (gridx + marginx)

    # Converts a CSS left position to a column unit.
    @leftToCol = (left) ->
      (left - marginx) / (gridx + marginx)

    # Converts a row unit to a CSS top position.
    @rowToTop = (row) ->
      marginy + row * (gridy + marginy)

    # Converts a CSS top position to a row unit.
    @topToRow = (top) ->
      (top - marginy) / (gridy + marginy)

    # Converts a grid sizex to a pixel width.
    @sizeToWidth = (size) ->
      if size <= 0
        return 0 if size is 0
        throw 'A size cannot be negative.'
      else
        size * (gridx + marginx) - marginx

    # Converts a pixel width to a grid sizex.
    @widthToSize = (width) ->
      if width <= 0
        return 0 if width is 0
        throw 'A width cannot be negative.'
      else
        (width + marginx) / (gridx + marginx)

    # Converts a grid sizey to a pixel height.
    @sizeToHeight = (size) ->
      if size <= 0
        return 0 if size is 0
        throw 'A size cannot be negative.'
      else
        size * (gridy + marginy) - marginy

    # Converts a pixel height to a grid sizey.
    @heightToSize = (height) ->
      if height <= 0
        return 0 if height is 0
        throw 'A height cannot be negative.'
      else
        (height + marginy) / (gridy + marginy)

  # Sets a grid area with an item.
  # @param item [anything]
  # @param col, row, sizex, sizey [whole number]
  # @return null
  set: (item, col, row, sizex = 1, sizey = 1) ->
    grid = @grid

    if col < 0 or row < 0 or sizex < 0 or sizey < 0
      throw 'col, row, sizex and sizey cannot be negative'

    for y in [0...sizey] by 1
      tempRow = row + y
      grid[tempRow] = [] if not grid[tempRow]

      for x in [0...sizex] by 1
        grid[tempRow][col + x] = item

    null

  # Gets items in a grid area, skipping duplicates.
  # @param col, row, sizex, sizey [whole number]
  # @return [Array]
  get: (col, row, sizex = 1, sizey = 1) ->
    grid = @grid
    inArray = $.inArray

    items = []

    for y in [0...sizey] by 1
      tempRow = row + y

      if grid[tempRow]
        for x in [0...sizex] by 1
          item = grid[tempRow][col + x]
          items.push(item) if item and inArray(item, items) is -1

    items

  # Removes items from a grid area.
  # @param col, row, sizex, sizey [whole number]
  # @return [null]
  clear: (col, row, sizex = 1, sizey = 1) ->
    grid = @grid

    for y in [0...sizey] by 1
      tempRow = row + y

      if grid[tempRow]
        for x in [0...sizex] by 1
          delete grid[tempRow][col + x]

    null



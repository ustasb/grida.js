# Represents a 2D grid.
# The origin is at the top left corner.
class Grid

  constructor: ->

    # 2D array
    @grid = [ [] ]

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

  # Removes items in a grid area.
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

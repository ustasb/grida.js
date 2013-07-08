# Represents a 2D matrix.
# Row/Column indices start at 0.
class Matrix2D

  constructor: ->

    @_array2D = [ [] ]

  # Sets a matrix area with an item.
  # @param item [anything]
  # @param col, row, sizex, sizey [whole number]
  # @return [null]
  set: (item, col, row, sizex = 1, sizey = 1) ->
    matrix = @_array2D

    if col < 0 or row < 0 or sizex < 0 or sizey < 0
      throw new RangeError('col, row, sizex and sizey cannot be negative.')

    for y in [0...sizey] by 1
      tempRow = row + y
      matrix[tempRow] = [] if matrix[tempRow] is undefined

      for x in [0...sizex] by 1
        matrix[tempRow][col + x] = item

    null

  # Gets items in a matrix area, skipping duplicates.
  # @param col, row, sizex, sizey [whole number]
  # @return [Array] Items in smaller rows are first.
  get: (col, row, sizex = 1, sizey = 1) ->
    matrix = @_array2D
    inArray = $.inArray

    items = []

    for y in [0...sizey] by 1
      tempRow = row + y

      if matrix[tempRow]
        for x in [0...sizex] by 1
          item = matrix[tempRow][col + x]
          items.push(item) if item? and inArray(item, items) is -1

    items

  # Removes items in a matrix area.
  # @param col, row, sizex, sizey [whole number]
  # @param filterItem [anything] If defined, only items equal to it are removed.
  # @return [null]
  clear: (col, row, sizex = 1, sizey = 1, filterItem = undefined) ->
    matrix = @_array2D

    for y in [0...sizey] by 1
      tempRow = row + y

      if matrix[tempRow]
        for x in [0...sizex] by 1
          if filterItem is undefined or filterItem is matrix[tempRow][col + x]
            delete matrix[tempRow][col + x]

    null

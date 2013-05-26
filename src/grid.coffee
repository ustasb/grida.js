class Grid

  constructor: (@el, @gridx, @gridy, @marginx = 0, @marginy = 0) ->
    @grid = []
    @updateMaxCol()

  sizeToRowUnit: (size) -> (size - @marginy) / (@marginy + @gridy)
  sizeToColUnit: (size) -> (size - @marginx) / (@marginx + @gridx)
  rowUnitToSize: (row) -> (row + 1) * @marginy + row * @gridy
  colUnitToSize: (col) -> (col + 1) * @marginx + col * @gridx

  updateMaxCol: ->
    containerWidth = $(@el).width()
    @maxCol = Math.floor(@sizeToColUnit(containerWidth)) - 1

  isEmpty: (row, col) ->
    return true if not @grid[row]
    return not @grid[row][col]

  insertAt: (gridElement, row, col) ->
    @grid[row] = [] if not @grid[row]

    @grid[row][col] = gridElement
    gridElement.moveTo(row, col)

  append: (gridElement, row = 0, col = 0) ->
    if col > @maxCol
      @append(gridElement, row + 1, 0)
    else if @isEmpty(row, col)
      @insertAt(gridElement, row, col)
    else
      @append(gridElement, row, col + 1)

class GridElement

  constructor: (@el, @grid, @draggable, @resizable) ->
    $el = $(el)

    @sizex = parseInt $el.data('xxx-sizex'), 10
    @sizey = parseInt $el.data('xxx-sizey'), 10

    el.style.width = @sizex * @grid.gridx + 'px'
    el.style.height = @sizey * @grid.gridy + 'px'

  moveTo: (row, col) ->
    @el.style.top = @grid.rowUnitToSize(row) + 'px'
    @el.style.left = @grid.colUnitToSize(col) + 'px'

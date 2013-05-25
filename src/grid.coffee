class Grid

  constructor: (@unity, @unitx, @marginx, @marginy) ->
    @grid = [[]]

  isEmpty: (row, col) ->
    return true if not @grid[row]
    return not @grid[row][col]

  insertAt: (gridElement, row, col) ->
    if not @grid[row]
      for i in [0..row]
        @grid[i] = [] if !@grid[i]

    @grid[row][col] = gridElement
    gridElement.moveTo(row, col)

  append: (gridElement, row = 0, col = 0) ->
    if @isEmpty(row, col)
      @insertAt(gridElement, row, col)
    else
      @append(gridElement, row + 1, col + 1)

class GridElement

  constructor: (@grid, @el, @draggable, @resizable) ->
    @sizex = parseInt @el.data('xxx-sizex')
    @sizey = parseInt @el.data('xxx-sizey')

    @el.css
      width: @sizex * @grid.unitx
      height: @sizey * @grid.unity

  moveTo: (row, col) ->
    @el.css
      left: (col + 1) * @grid.marginx + col * @grid.unitx
      top: (row + 1) * @grid.marginy + row * @grid.unity

class Grid

  constructor: (@containerEl, @gridx, @gridy, @marginx = 0, @marginy = 0) ->
    @grid = []
    @members = []

    @updateMaxCol()
    @updateOffsetLeft()
    @initEvents()

  initEvents: ->
    $WINDOW.resize =>
      @updateMaxCol()
      @updateOffsetLeft()

      @grid = []
      @append(member) for member in @members

  sizeToRowUnit: (size) ->
    (size - @offsetLeft - @marginy) / (@marginy + @gridy)
  sizeToColUnit: (size) ->
    (size - @marginx) / (@marginx + @gridx)
  rowUnitToSize: (row) ->
    (row + 1) * @marginy + row * @gridy
  colUnitToSize: (col) ->
    (col + 1) * @marginx + col * @gridx + @offsetLeft

  updateMaxCol: ->
    containerWidth = $(@containerEl).width()
    @maxCol = Math.floor(@sizeToColUnit(containerWidth)) - 1

  updateOffsetLeft: ->
    containerWidth = $(@containerEl).width()
    maxElements = @maxCol + 1
    gridWidth = maxElements * (@gridx + @marginx) + @marginx
    @offsetLeft = (containerWidth - gridWidth) / 2

  isEmpty: (row, col) ->
    if not @grid[row]
      true
    else
      not @grid[row][col]

  insertAt: (gridMember, row, col) ->
    @grid[row] = [] if not @grid[row]

    @grid[row][col] = gridMember
    gridMember.moveTo(row, col)

  append: (gridMember, row = 0, col = 0) ->
    if col > @maxCol
      @append(gridMember, row + 1, 0)
    else if @isEmpty(row, col)
      @insertAt(gridMember, row, col)
      return col
    else
      @append(gridMember, row, col + 1)

  addElement: (el, draggable, resizable) ->
    member = new GridMember(@, el, draggable, resizable)
    @members.push(member)
    @append(member)


class GridMember

  constructor: (@grid, @el, @draggable, @resizable) ->
    $el = $(el)

    @sizex = parseInt $el.data('xxx-sizex'), 10
    @sizey = parseInt $el.data('xxx-sizey'), 10

    el.style.width = @sizex * @grid.gridx + 'px'
    el.style.height = @sizey * @grid.gridy + 'px'

  moveTo: (row, col) ->
    @el.style.top = @grid.rowUnitToSize(row) + 'px'
    @el.style.left = @grid.colUnitToSize(col) + 'px'

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
    @maxCol = 0 if @maxCol < 0

  updateOffsetLeft: ->
    containerWidth = $(@containerEl).width()
    maxElements = @maxCol + 1
    gridWidth = @marginx + maxElements * (@gridx + @marginx)
    @offsetLeft = (containerWidth - gridWidth) / 2

  isEmpty: (row, col) ->
    if not @grid[row]
      true
    else
      not @grid[row][col]

  insertAt: (gridMember, row, col) ->
    @grid[row] = [] if not @grid[row]

    @vacate(gridMember)
    currentMember = @grid[row][col]

    if currentMember and currentMember isnt gridMember
      @insertAt(currentMember, row + gridMember.sizey, col)

    @grid[row][col] = gridMember
    gridMember.moveTo(row, col)

  # Empties the cells occupied by the grid member.
  vacate: (gridMember) ->
    for y in [0...gridMember.sizey]
      for x in [0...gridMember.sizex]
        delete @grid[gridMember.row + y]?[gridMember.col + x]

  append: (gridMember, row = 0, col = 0) ->
    if col > @maxCol
      @append(gridMember, row + 1, 0)
    else if @isEmpty(row, col)
      @insertAt(gridMember, row, col)
    else
      @append(gridMember, row, col + 1)

  addElement: (el, draggable, resizable) ->
    member = new GridMember(@, el, draggable, resizable)
    @members.push(member)
    @append(member)

class GridMember

  constructor: (@grid, @el, @draggable, @resizable) ->
    $el = $(el)

    @sizex = $el.data('xxx-sizex') or 1
    @sizey = $el.data('xxx-sizey') or 1

    el.style.width = @sizex * @grid.gridx + 'px'
    el.style.height = @sizey * @grid.gridy + 'px'

    @initEvents()

  initEvents: ->
    $el = $(@el)

    $el.on 'xxx-draggable-snap', (e, left, top) =>
      row = Math.round @grid.sizeToRowUnit(top)
      col = Math.round @grid.sizeToColUnit(left)

      @grid.insertAt(@, row, col)
      #console.log(row, col)

  getBelowNeighbors: ->
    neighbors = []

    neighborRow = @row + @sizey
    if not @grid.isEmpty(neighborRow, @col)
      for x in [0...@sizex]
        neighbor = @grid.grid[neighborRow][@col + x]
        neighbors.push neighbor if neighbor

    neighbors

  moveTo: (@row, @col) ->
    @el.style.top = @grid.rowUnitToSize(row) + 'px'
    @el.style.left = @grid.colUnitToSize(col) + 'px'

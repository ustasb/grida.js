class Grid

  constructor: (@containerEl, @gridx, @gridy, @marginx = 0, @marginy = 0) ->
    @maxCol = 0
    @maxRow = 0

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

  topToRowUnit: (top) ->
    (top - @marginy) / (@marginy + @gridy)
  leftToColUnit: (left) ->
    (left - @offsetLeft - @marginx) / (@marginx + @gridx)
  rowUnitToTop: (row) ->
    (row + 1) * @marginy + row * @gridy
  colUnitToLeft: (col) ->
    (col + 1) * @marginx + col * @gridx + @offsetLeft

  sizeToWidth: (size) ->
    size * @gridx + (size - 1) * @marginx
  sizeToHeight: (size) ->
    size * @gridy + (size - 1) * @marginy
  widthToSize: (width) ->
    (width - @marginx) / (@marginx + @gridx)
  heightToSize: (height) ->
    (height - @marginy) / (@marginy + @gridy)

  updateMaxCol: ->
    containerWidth = $(@containerEl).width()
    @maxCol = Math.floor(@widthToSize(containerWidth)) - 1
    @maxCol = 0 if @maxCol < 0

  updateOffsetLeft: ->
    containerWidth = $(@containerEl).width()
    maxElements = @maxCol + 1
    gridWidth = @marginx + maxElements * (@gridx + @marginx)
    @offsetLeft = (containerWidth - gridWidth) / 2

  set: (gridMember, row, col) ->
    for y in [0...gridMember.sizey]
      nextRow = row + y
      @grid[nextRow] = [] if not @grid[nextRow]

      for x in [0...gridMember.sizex]

        if gridMember.row isnt null
          # Empty currently occupied cells.
          delete @grid[gridMember.row + y]?[gridMember.col + x]

        @grid[nextRow][col + x] = gridMember

  get: (row, col) ->
    if not @grid[row]
      null
    else
      @grid[row][col]

  isSpaceFree: (row, col, sizex, sizey) ->
    for y in [0...sizey]
      for x in [0...sizex]
        return false if @get(row + y, col + x)
    true

  getMembersAt: (row, col, sizex, sizey, members = {}) ->
    for y in [0...sizey]
      tempRow = row + y

      for x in [0...sizex]
        member = @grid[tempRow][col + x]
        if member
          members[member.hash] = member  # Ensure a unique list

    members

  getInfluencingMembersBelow: (row, col, sizex = 1, members = {}) ->
    sizey = @grid.length - row
    maxCol = col + (sizex - 1)

    for y in [0...sizey] by 1
      tempRow = row + y

      for x in [0...sizex] by 1
        member = @get(tempRow, col + x)

        if member and members[member.hash] is undefined
          members[member.hash] = member  # Ensure a unique list

          #if member.col < col
            #@getInfluencingMembersBelow(tempRow, member.col, col - member.col, members)

          #memberMaxCol = member.col + member.sizex
          #if memberMaxCol > maxCol
            #@getInfluencingMembersBelow(tempRow, maxCol + 1, memberMaxCol - maxCol, members)

    members

  insertAt: (gridMember, row, col) ->
    #maxRow = @grid.length
    #members = @getMembersAt(row, col, gridMember.sizex, maxRow - row)
    #for _, member of members
      #if member.col < col
        #@getMembersAt(member.row, member.col, col - member.col, maxRow - member.row, members)

    @set(gridMember, row, col)
    gridMember.moveTo(row, col)

  append: (gridMember, row = 0, col = 0) ->
    sizex = gridMember.sizex
    sizey = gridMember.sizey
    memberMaxCol = col + (sizex - 1)

    if memberMaxCol > @maxCol
      if sizex > (@maxCol + 1) and @isSpaceFree(row, col, sizex, sizey)
        @insertAt(gridMember, row, 0)
      else
        @append(gridMember, row + 1, 0)
    else if @isSpaceFree(row, col, sizex, sizey)
      @insertAt(gridMember, row, col)
    else
      @append(gridMember, row, col + 1)


  addElement: (el) ->
    member = new GridMember(@, el)
    @members.push(member)
    @append(member)

class GridMember
  _count = 0

  constructor: (@grid, @el) ->
    $el = $(el)

    @row = null
    @col = null

    @sizex = $el.data('xxx-sizex') or 1
    @sizey = $el.data('xxx-sizey') or 1

    @hash = _count++

    @resizeTo(@sizex, @sizey)
    @initEvents()

  initEvents: ->
    $el = $(@el)

    $el.on 'xxx-draggable-snap', (e, left, top) =>
      row = Math.round @grid.topToRowUnit(top)
      col = Math.round @grid.leftToColUnit(left)

      @grid.insertAt(@, row, col)

    $el.on 'xxx-resizable-snap', (e, width, height) =>
      @sizex = Math.round @grid.widthToSize(width)
      @sizey = Math.round @grid.heightToSize(height)

  getBelowNeighbors: ->
    neighbors = []

    neighborRow = @row + @sizey
    for x in [0...@sizex]
      neighbor = @grid.get(neighbor, @col + x)
      neighbors.push neighbor if neighbor

    neighbors

  moveTo: (@row, @col) ->
    @el.style.top = @grid.rowUnitToTop(row) + 'px'
    @el.style.left = @grid.colUnitToLeft(col) + 'px'

  resizeTo: (@sizex, @sizey) ->
    @el.style.width = @grid.sizeToWidth(sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(sizey) + 'px'

class Grid

  constructor: (@containerEl, @gridx, @gridy, @marginx = 0, @marginy = 0) ->
    @maxCol = 0
    #@maxRow = 0

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

  get: (row, col) ->
    if not @grid[row]
      null
    else
      @grid[row][col]

  set: (gridMember, row, col) ->
    for y in [0...gridMember.sizey]
      tempRow = row + y
      @grid[tempRow] = [] if not @grid[tempRow]

      for x in [0...gridMember.sizex]
        @grid[tempRow][col + x] = gridMember

  remove: (gridMember) ->
    return if gridMember.row is null

    for y in [0...gridMember.sizey]
      tempRow = gridMember.row + y
      for x in [0...gridMember.sizex]
        delete @grid[tempRow][gridMember.col + x]

    #gridMember.row = gridMember.col = null

  isSpaceFree: (row, col, sizex, sizey) ->
    for y in [0...sizey]
      for x in [0...sizex]
        return false if @get(row + y, col + x)
    true

  getMembersAt: (row, col, sizex, sizey, members = {}) ->
    for y in [0...sizey]
      tempRow = row + y

      for x in [0...sizex]
        member = @get(tempRow, col + x)
        members[member.id] = member if member

    members

  isInsertionPossibleAt: (newMember, row, col) ->
    sizex = newMember.sizex
    sizey = newMember.sizey

    newMaxCol = col + (sizex - 1)

    # Outside the boundaries?
    if col < 0 or row < 0 or newMaxCol > @maxCol
      return false

    if row is 0
      return true
    else
      members = @getMembersAt(row, col, sizex, sizey)
      aboveNeighbors = @getMembersAt(row - 1, col, sizex, 1)

      delete aboveNeighbors[newMember.id]
      delete aboveNeighbors[member.id] for _, member of members

      return not $.isEmptyObject(aboveNeighbors)

  insertAt: (gridMember, row, col) ->
    @remove(gridMember)

    membersAtNewLocation = @getMembersAt(row, col, gridMember.sizex, gridMember.sizey)
    #delete membersAtNewLocation[gridMember.id]

    belowMembers = {}

    for _, member of membersAtNewLocation
      continue if belowMembers[member.id]

      belowMembers = member.getInfluencingMembersBelow()
      belowMembers[member.id] = member

      dy = (row - member.row) + gridMember.sizey

      @remove(child) for _, child of belowMembers
      for _, child of belowMembers
        @set(child, child.row + dy, child.col)
        child.moveTo(child.row + dy, child.col)

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
  _count = 1

  constructor: (@grid, @el) ->
    $el = $(el)

    @id = _count++

    @row = null
    @col = null

    @sizex = $el.data('xxx-sizex') or 1
    @sizey = $el.data('xxx-sizey') or 1

    @resizeTo(@sizex, @sizey)
    @initEvents()

  initEvents: ->
    $el = $(@el)

    $el.on 'xxx-draggable-snap', (e, row, col) =>
      console.log row, col
      console.log @grid.isInsertionPossibleAt(@, row, col)

      if @grid.isInsertionPossibleAt(@, row, col)
        @grid.insertAt(@, row, col)


      #@grid.insertAt(@, row, col)

    #$el.on 'xxx-resizable-snap', (e, width, height) =>
      #@sizex = Math.round @grid.widthToSize(width)
      #@sizey = Math.round @grid.heightToSize(height)

  getInfluencingMembersBelow: (members = {}) ->
    neighborRow = @row + @sizey

    for x in [0...@sizex]
      neighbor = @grid.get(neighborRow, @col + x)
      if neighbor
        members[neighbor.id] = neighbor
        neighbor.getInfluencingMembersBelow(members)

    members

  moveTo: (@row, @col) ->
    @el.style.top = @grid.rowUnitToTop(row) + 'px'
    @el.style.left = @grid.colUnitToLeft(col) + 'px'

  resizeTo: (@sizex, @sizey) ->
    @el.style.width = @grid.sizeToWidth(sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(sizey) + 'px'

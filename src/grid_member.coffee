class GridMember
  _count = 1

  constructor: (@grid, @el) ->
    $el = $(el)

    @id = _count++

    @$ghost = null
    @row = null
    @col = null

    @sizex = $el.data('xxx-sizex') or 1
    @sizey = $el.data('xxx-sizey') or 1

    @resizeTo(@sizex, @sizey)
    @initEvents()

  initEvents: ->
    $el = $(@el)

    $el.on 'xxx-draggable-mousedown', (e) =>
      console.log('down')
      @$ghost = $el.clone().css
        zIndex: -1
        opacity: 0.2
        backgroundColor: 'blue'

      @$ghost.appendTo($el.parent())

    $el.on 'xxx-draggable-mouseup', (e) =>
      console.log('up')

      if @$ghost
        @$ghost.remove()
        @$ghost = null

      @el.style.top = @grid.rowUnitToTop(@row) + 'px'
      @el.style.left = @grid.colUnitToLeft(@col) + 'px'

    $el.on 'xxx-draggable-snap', (e, row, col) =>
      console.log row, col
      console.log !!@grid.isInsertionPossibleAt(@, row, col)

      oldChildren = @getInfluencingMembersBelow({}, false)

      switch @grid.isInsertionPossibleAt(@, row, col)
        when InsertionType.TRADE
          console.log('trade')
          @grid.remove(@)

          for _, member of oldChildren
            if member.sizey is (row - @row)
              @grid.remove(member)
              @grid.set(member, @row, member.col)
              member.moveTo(@row, member.col)

          @grid.insertAt(@, row, col)

        when InsertionType.SHIFT_DOWN
          console.log('shift down')

          @grid.insertAt(@, row, col)

          for _, member of oldChildren
            member.collapseAboveWhiteSpace()

    #$el.on 'xxx-resizable-snap', (e, width, height) =>
      #@sizex = Math.round @grid.widthToSize(width)
      #@sizey = Math.round @grid.heightToSize(height)

  collapseAboveWhiteSpace: (recursive = true) ->
    grid = @grid
    children = if recursive then @getInfluencingMembersBelow({}, false) else {}

    dy = 0
    aboveRow = @row - 1

    while aboveRow >= 0 and $.isEmptyObject grid.getMembersAt(aboveRow, @col, @sizex, 1)
      dy += 1
      aboveRow = @row - 1 - dy

    if dy > 0
      console.log @id
      grid.remove(@)
      grid.set(@, @row - dy, @col)
      @moveTo(@row - dy, @col)

    for _, member of children
      member.collapseAboveWhiteSpace(true)

  getInfluencingMembersBelow: (members = {}, recursive = true) ->
    neighborRow = @row + @sizey

    for x in [0...@sizex]
      neighbor = @grid.get(neighborRow, @col + x)
      if neighbor
        members[neighbor.id] = neighbor
        neighbor.getInfluencingMembersBelow(members) if recursive

    members

  moveTo: (@row, @col) ->
    top = @grid.rowUnitToTop(row) + 'px'
    left = @grid.colUnitToLeft(col) + 'px'

    @el.style.top = top
    @el.style.left = left

    if @$ghost
      @$ghost.css
        top: top
        left: left

  resizeTo: (@sizex, @sizey) ->
    @el.style.width = @grid.sizeToWidth(sizex) + 'px'
    @el.style.height = @grid.sizeToHeight(sizey) + 'px'

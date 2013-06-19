$.fn.grida = (opts) ->

  marginx = opts.margins[0]
  marginy = opts.margins[1]
  tilex = opts.base_dimensions[0]
  tiley = opts.base_dimensions[1]

  grid = new HTMLTileGrid(this, tilex, tiley, marginx, marginy)

  for child in this.children()
    $child = $(child)
    sizex = $child.data('xxx-sizex')
    sizey = $child.data('xxx-sizey')

    tile = new HTMLTile(child, grid, sizex, sizey)
    grid.appendAtFreeSpace(tile)

  HTMLTile.updateChangedTiles()

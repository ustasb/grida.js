$.fn.grida = (opts) ->

  grid = new Grid(this.get(),
                  opts.grid.x,
                  opts.grid.y,
                  opts.margin.x,
                  opts.margin.y)

  # Draggables needs to be created in reverse order to prevent element
  # collapsing when absolute positioning is applied.
  children = @children().get().reverse()
  for el in children
    Draggable.create(el, grid)

  for el in children.reverse()
    grid.addElement(el)

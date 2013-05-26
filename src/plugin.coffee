$.fn.grida = (opts) ->
  grid = opts.grid
  margin = opts.margin

  # Draggables needs to be created in reverse order to prevent element
  # collapsing when absolute positioning is applied.
  gridElArgs = []
  for el in @children().get().reverse()
    gridElArgs.push [
      el,
      Draggable.create(el,
        grid: grid
        margin: margin
      ),
      Resizable.create(el,
        grid: grid
        margin: margin
      )
    ]

  grid = new Grid(this.get(), grid.x, grid.y, margin.x, margin.y)

  for args in gridElArgs.reverse()
    grid.append new GridElement(args[0], grid, args[1], args[2])

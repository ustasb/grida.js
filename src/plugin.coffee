$.fn.grida = (opts) ->
  # Draggables needs to be created in reverse order to prevent element
  # collapsing when absolute positioning is applied.
  gridElArgs = []
  for el in @children().get().reverse()
    gridElArgs.push [
      $(el),
      new Draggable(el, opts.grid[0] + opts.margin[0], opts.margin[0]),
      new Resizable(el, opts.grid[0], opts.margin[0])
    ]

  grid = new Grid(opts.grid[0], opts.grid[1], opts.margin[0], opts.margin[1])

  for args in gridElArgs.reverse()
    grid.append new GridElement(grid, args...)

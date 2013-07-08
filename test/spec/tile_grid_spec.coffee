describe 'A TileGrid class', ->
  u = undefined
  grid = null
  gridArray = null
  t1x1 = null
  t1x2 = null
  t1x3 = null
  t2x1 = null
  t2x2 = null
  t2x3 = null
  t3x1 = null
  t3x2 = null
  t3x3 = null

  beforeEach ->
    grid = new TileGrid(10, 20, 5, 15)
    gridArray = grid.grid._array2D
    t1x1 = new Tile(1, 1)
    t1x2 = new Tile(1, 2)
    t1x3 = new Tile(1, 3)
    t2x1 = new Tile(2, 1)
    t2x2 = new Tile(2, 2)
    t2x3 = new Tile(2, 3)
    t3x1 = new Tile(3, 1)
    t3x2 = new Tile(3, 2)
    t3x3 = new Tile(3, 3)

  describe '#getLowestAboveRow', ->

    it 'finds the lowest above row that the tile could shift up to', ->
      grid.insertAt(t1x1, 0, 0)
      expect(gridArray).toLookLike([
        [t1x1]
      ])
      expect(grid.getLowestAboveRow(t1x1)).toEqual(0)

      grid.insertAt(t3x2, 0, 3)
      expect(gridArray).toLookLike([
        [t1x1,    u,    u]
        [   u,    u,    u]
        [   u,    u,    u]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(1)

      grid.insertAt(t1x2, 1, 0)
      expect(gridArray).toLookLike([
        [t1x1, t1x2,    u]
        [   u, t1x2,    u]
        [   u,    u,    u]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(2)

      grid.insertAt(t1x3, 2, 0)
      expect(gridArray).toLookLike([
        [t1x1, t1x2, t1x3]
        [   u, t1x2, t1x3]
        [   u,    u, t1x3]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(3)

  describe '#insertAt', ->
    it 'inserts a tile at a grid position', ->
      grid.insertAt(t1x1, 0, 0)
      expect(gridArray).toLookLike([
        [t1x1]
      ])

      grid.insertAt(t1x2, 0, 1)
      expect(gridArray).toLookLike([
        [t1x1]
        [t1x2]
        [t1x2]
      ])

      grid.insertAt(t2x1, 1, 0)
      expect(gridArray).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2,    u,    u]
        [t1x2,    u,    u]
      ])

      grid.insertAt(t2x2, 1, 1)
      expect(gridArray).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2, t2x2, t2x2]
        [t1x2, t2x2, t2x2]
      ])

      grid.insertAt(t3x3, 0, 3)
      expect(gridArray).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2, t2x2, t2x2]
        [t1x2, t2x2, t2x2]
        [t3x3, t3x3, t3x3]
        [t3x3, t3x3, t3x3]
        [t3x3, t3x3, t3x3]
      ])

      # Shift all tiles 3 columns right.
      grid.insertAt(t1x1, 3, 0)
      grid.insertAt(t1x2, 3, 1)
      grid.insertAt(t2x1, 4, 0)
      grid.insertAt(t2x2, 4, 1)
      grid.insertAt(t3x3, 3, 3)
      expect(gridArray).toLookLike([
        [   u,    u,    u, t1x1, t2x1, t2x1]
        [   u,    u,    u, t1x2, t2x2, t2x2]
        [   u,    u,    u, t1x2, t2x2, t2x2]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
      ])

    describe 'when a collision occurs', ->

      it 'shifts the obstructing tiles down', ->
        grid.insertAt(t3x1, 0, 2)
        grid.insertAt(t1x1, 0, 0)
        grid.insertAt(t2x1, 0, 0)
        expect(gridArray).toLookLike([
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insertAt(t1x2, 1, 0)
        expect(gridArray).toLookLike([
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insertAt(t2x3, 0, 0)
        expect(gridArray).toLookLike([
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insertAt(t2x2, 0, 0)
        expect(gridArray).toLookLike([
          [t2x2, t2x2,    u]
          [t2x2, t2x2,    u]
          [t2x3, t2x3,    u] # <--
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insertAt(t2x2, 0, 3)
        expect(gridArray).toLookLike([
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [t2x2, t2x2,    u]
          [t2x2, t2x2,    u]
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u] # <--
          [t2x3, t2x3,    u]
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insertAt(t2x2, 0, 7)
        expect(gridArray).toLookLike([
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [   u,    u,    u]
          [t2x2, t2x2,    u]
          [t2x2, t2x2,    u]
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u] # <--
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

  describe '#collapseAboveEmptySpace', ->

    it 'moves a tile upwards until it encounters a barrier', ->
      grid.insertAt(t1x1, 0, 1)
      expect(gridArray).toLookLike([
        [   u]
        [t1x1]
      ])
      grid.collapseAboveEmptySpace(t1x1)
      expect(gridArray).toLookLike([
        [t1x1]
      ])

      grid.insertAt(t2x2, 0, 4)
      expect(gridArray).toLookLike([
        [t1x1,    u]
        [   u,    u]
        [   u,    u]
        [   u,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])
      grid.collapseAboveEmptySpace(t2x2)
      expect(gridArray).toLookLike([
        [t1x1,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])

      grid.insertAt(t3x2, 2, 4)
      expect(gridArray).toLookLike([
        [t1x1,    u,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u,    u, t3x2, t3x2, t3x2]
        [   u,    u, t3x2, t3x2, t3x2]
      ])
      grid.collapseAboveEmptySpace(t3x2)
      expect(gridArray).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
      ])

      grid.insertAt(t2x1, 1, 4)
      expect(gridArray).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])
      grid.collapseAboveEmptySpace(t2x1)
      expect(gridArray).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])

  describe '#attemptInsertAt', ->
    it 'checks if a tile can be inserted into a new position', ->
      grid.insertAt(t1x1, 0, 2)
      grid.insertAt(t1x2, 0, 0)
      grid.insertAt(t1x3, 3, 0)
      grid.insertAt(t2x1, 1, 0)
      grid.insertAt(t2x2, 0, 3)
      grid.insertAt(t2x3, 3, 3)
      grid.insertAt(t3x1, 0, 5)
      grid.insertAt(t3x2, 1, 6)
      grid.insertAt(t3x3, 3, 8)
      expect(gridArray).toLookLike([
        [t1x2, t2x1, t2x1, t1x3,    u,    u]
        [t1x2,    u,    u, t1x3,    u,    u]
        [t1x1,    u,    u, t1x3,    u,    u]
        [t2x2, t2x2,    u, t2x3, t2x3,    u]
        [t2x2, t2x2,    u, t2x3, t2x3,    u]
        [t3x1, t3x1, t3x1, t2x3, t2x3,    u]
        [   u, t3x2, t3x2, t3x2,    u,    u]
        [   u, t3x2, t3x2, t3x2,    u,    u]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
      ])

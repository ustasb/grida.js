describe 'A TileGrid class', ->
  u = undefined
  grid = null
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
    t1x1 = new Tile(1, 1)
    t1x2 = new Tile(1, 2)
    t1x3 = new Tile(1, 3)
    t2x1 = new Tile(2, 1)
    t2x2 = new Tile(2, 2)
    t2x3 = new Tile(2, 3)
    t3x1 = new Tile(3, 1)
    t3x2 = new Tile(3, 2)
    t3x3 = new Tile(3, 3)

  describe '#collapseAboveEmptySpace', ->
    it 'target row cannot be less than 0', ->
      grid.insertAt(t1x1, 0, 1)
      expect(grid.grid).toLookLike([
        [   u]
        [t1x1]
      ])
      expect(-> grid.collapseAboveEmptySpace(t1x1, -1)).toThrow()

    it 'moves a tile upward until a barrier is reached', ->
      grid.insertAt(t1x1, 0, 1)
      expect(grid.grid).toLookLike([
        [   u]
        [t1x1]
      ])

      grid.collapseAboveEmptySpace(t1x1, 0)
      expect(grid.grid).toLookLike([
        [t1x1]
      ])

      grid.insertAt(t2x2, 0, 4)
      expect(grid.grid).toLookLike([
        [t1x1,    u]
        [   u,    u]
        [   u,    u]
        [   u,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])

      grid.collapseAboveEmptySpace(t2x2, 0)
      expect(grid.grid).toLookLike([
        [t1x1,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])

      grid.insertAt(t3x2, 2, 4)
      expect(grid.grid).toLookLike([
        [t1x1,    u,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u,    u, t3x2, t3x2, t3x2]
        [   u,    u, t3x2, t3x2, t3x2]
      ])
      grid.collapseAboveEmptySpace(t3x2, 0)
      expect(grid.grid).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
      ])

      grid.insertAt(t2x1, 1, 4)
      expect(grid.grid).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])
      grid.collapseAboveEmptySpace(t2x1, 0)
      expect(grid.grid).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])

      grid.insertAt(t1x1, 3, 5)
      expect(grid.grid).toLookLike([
        [   u,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u,    u,    u, t1x1,    u]
      ])
      grid.collapseAboveEmptySpace(t1x1, 3)
      expect(grid.grid).toLookLike([
        [   u,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1, t1x1,    u]
      ])

      grid.insertAt(t1x2, 4, 4)
      expect(grid.grid).toLookLike([
        [   u,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1, t1x1,    u]
        [   u,    u,    u,    u, t1x2]
        [   u,    u,    u,    u, t1x2]
      ])
      grid.collapseAboveEmptySpace(t1x2, 0)
      expect(grid.grid).toLookLike([
        [   u,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u, t1x2]
        [   u, t2x1, t2x1, t1x1, t1x2]
      ])

  describe '#insertAt', ->
    it 'inserts a tile at a grid position', ->
      grid.insertAt(t1x1, 0, 0)
      expect(grid.grid).toLookLike([
        [t1x1]
      ])

      grid.insertAt(t1x2, 0, 1)
      expect(grid.grid).toLookLike([
        [t1x1]
        [t1x2]
        [t1x2]
      ])

      grid.insertAt(t2x1, 1, 0)
      expect(grid.grid).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2,    u,    u]
        [t1x2,    u,    u]
      ])

      grid.insertAt(t2x2, 1, 1)
      expect(grid.grid).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2, t2x2, t2x2]
        [t1x2, t2x2, t2x2]
      ])

      grid.insertAt(t3x3, 2, 3)
      expect(grid.grid).toLookLike([
        [t1x1, t2x1, t2x1,    u,    u]
        [t1x2, t2x2, t2x2,    u,    u]
        [t1x2, t2x2, t2x2,    u,    u]
        [   u,    u, t3x3, t3x3, t3x3]
        [   u,    u, t3x3, t3x3, t3x3]
        [   u,    u, t3x3, t3x3, t3x3]
      ])

      grid.insertAt(t1x2, 0, 4)
      expect(grid.grid).toLookLike([
        [t1x1, t2x1, t2x1,    u,    u]
        [   u, t2x2, t2x2,    u,    u]
        [   u, t2x2, t2x2,    u,    u]
        [   u,    u, t3x3, t3x3, t3x3]
        [t1x2,    u, t3x3, t3x3, t3x3]
        [t1x2,    u, t3x3, t3x3, t3x3]
      ])

      grid.insertAt(t2x1, 3, 2)
      expect(grid.grid).toLookLike([
        [t1x1,    u,    u,    u,    u]
        [   u, t2x2, t2x2,    u,    u]
        [   u, t2x2, t2x2, t2x1, t2x1]
        [   u,    u, t3x3, t3x3, t3x3]
        [t1x2,    u, t3x3, t3x3, t3x3]
        [t1x2,    u, t3x3, t3x3, t3x3]
      ])

      grid.insertAt(t3x3, 0, 6)
      expect(grid.grid).toLookLike([
        [t1x1,    u,    u,    u,    u]
        [   u, t2x2, t2x2,    u,    u]
        [   u, t2x2, t2x2, t2x1, t2x1]
        [   u,    u,    u,    u,    u]
        [t1x2,    u,    u,    u,    u]
        [t1x2,    u,    u,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
      ])

    describe 'when a collision occurs', ->

      it 'shifts the colliding tiles down', ->
        grid.insertAt(t2x1, 0, 0)
        expect(grid.grid).toLookLike([
          [t2x1, t2x1]
        ])

        grid.insertAt(t1x1, 0, 0)
        expect(grid.grid).toLookLike([
          [t1x1,    u]
          [t2x1, t2x1]
        ])

        grid.insertAt(t2x2, 1, 0)
        expect(grid.grid).toLookLike([
          [t1x1, t2x2, t2x2]
          [   u, t2x2, t2x2]
          [t2x1, t2x1,    u]
        ])

        grid.insertAt(t3x1, 0, 0)
        expect(grid.grid).toLookLike([
          [t3x1, t3x1, t3x1]
          [t1x1, t2x2, t2x2]
          [   u, t2x2, t2x2]
          [t2x1, t2x1,    u]
        ])

        grid.insertAt(t3x3, 1, 1)
        expect(grid.grid).toLookLike([
          [t3x1, t3x1, t3x1,    u]
          [t1x1, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t1x2, 3, 0)
        expect(grid.grid).toLookLike([
          [t3x1, t3x1, t3x1, t1x2]
          [t1x1,    u,    u, t1x2]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t2x3, 0, 5)
        expect(grid.grid).toLookLike([
          [t3x1, t3x1, t3x1, t1x2]
          [t1x1,    u,    u, t1x2]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t3x2, 0, 0)
        expect(grid.grid).toLookLike([
          [t3x2, t3x2, t3x2, t1x2]
          [t3x2, t3x2, t3x2, t1x2]
          [t3x1, t3x1, t3x1,    u]
          [t1x1, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t3x2, 0, 3)
        expect(grid.grid).toLookLike([
          [   u,    u,    u, t1x2]
          [   u,    u,    u, t1x2]
          [t3x1, t3x1, t3x1,    u]
          [t3x2, t3x2, t3x2,    u]
          [t3x2, t3x2, t3x2,    u]
          [t1x1, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t3x3, 1, 7)
        expect(grid.grid).toLookLike([
          [   u,    u,    u, t1x2]
          [   u,    u,    u, t1x2]
          [t3x1, t3x1, t3x1,    u]
          [t3x2, t3x2, t3x2,    u]
          [t3x2, t3x2, t3x2,    u]
          [t1x1,    u,    u,    u]
          [   u,    u,    u,    u]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [   u, t3x3, t3x3, t3x3]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

        grid.insertAt(t3x3, 0, 4)
        expect(grid.grid).toLookLike([
          [   u,    u,    u, t1x2]
          [   u,    u,    u, t1x2]
          [t3x1, t3x1, t3x1,    u]
          [   u,    u,    u,    u]
          [t3x3, t3x3, t3x3,    u]
          [t3x3, t3x3, t3x3,    u]
          [t3x3, t3x3, t3x3,    u]
          [t3x2, t3x2, t3x2,    u]
          [t3x2, t3x2, t3x2,    u]
          [t1x1,    u,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [t2x3, t2x3,    u,    u]
          [   u, t2x2, t2x2,    u]
          [   u, t2x2, t2x2,    u]
          [t2x1, t2x1,    u,    u]
        ])

  describe '#swapWithTilesAt', ->
    it 'swaps a tile with the tiles at a given location if possible', ->
      grid.insertAt(t1x1, 0, 0)
      grid.insertAt(t1x2, 1, 0)
      expect(grid.grid).toLookLike([
        [t1x1, t1x2]
        [   u, t1x2]
      ])

      expect(grid.swapWithTilesAt(t1x1, 0, 0)).toBe(false)
      expect(grid.grid).toLookLike([
        [t1x1, t1x2]
        [   u, t1x2]
      ])

      expect(grid.swapWithTilesAt(t1x1, 1, 0)).toBe(true)
      expect(grid.grid).toLookLike([
        [t1x2, t1x1]
        [t1x2,    u]
      ])

      expect(grid.swapWithTilesAt(t1x1, 1, 1)).toBe(true)
      expect(grid.grid).toLookLike([
        [t1x2,    u]
        [t1x2, t1x1]
      ])

      expect(grid.swapWithTilesAt(t1x1, 0, 1)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t1x2]
        [t1x1, t1x2]
      ])

      grid.insertAt(t2x2, 3, 1)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u]
        [t1x1, t1x2,    u, t2x2, t2x2]
        [   u,    u,    u, t2x2, t2x2]
      ])

      expect(grid.swapWithTilesAt(t1x1, 3, 1)).toBe(false)
      expect(grid.swapWithTilesAt(t1x1, 4, 1)).toBe(false)
      expect(grid.swapWithTilesAt(t1x1, 4, 2)).toBe(false)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u]
        [t1x1, t1x2,    u, t2x2, t2x2]
        [   u,    u,    u, t2x2, t2x2]
      ])

      grid.insertAt(t3x3, 0, 3)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u]
        [t1x1, t1x2,    u, t2x2, t2x2]
        [   u,    u,    u, t2x2, t2x2]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
      ])

      expect(grid.swapWithTilesAt(t3x3, 3, 1)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u,    u]
        [t1x1, t1x2,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [t2x2, t2x2,    u, t3x3, t3x3, t3x3]
        [t2x2, t2x2,    u,    u,    u,    u]
      ])

      expect(grid.swapWithTilesAt(t3x3, 3, 0)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u, t3x3, t3x3, t3x3]
        [t1x1, t1x2,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [t2x2, t2x2,    u,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u,    u]
      ])

      expect(grid.swapWithTilesAt(t3x3, 4, 2)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u,    u,    u]
        [t1x1, t1x2,    u,    u,    u,    u,    u]
        [   u,    u,    u,    u, t3x3, t3x3, t3x3]
        [t2x2, t2x2,    u,    u, t3x3, t3x3, t3x3]
        [t2x2, t2x2,    u,    u, t3x3, t3x3, t3x3]
      ])

      expect(grid.swapWithTilesAt(t2x2, 4, 3)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t1x2,    u,    u,    u,    u]
        [t1x1, t1x2,    u,    u,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u,    u]
        [t3x3, t3x3, t3x3,    u, t2x2, t2x2]
        [t3x3, t3x3, t3x3,    u, t2x2, t2x2]
      ])

      expect(grid.swapWithTilesAt(t2x2, 1, 0)).toBe(true)
      expect(grid.grid).toLookLike([
        [   u, t2x2, t2x2,    u,    u]
        [t1x1, t2x2, t2x2,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u, t1x2]
        [t3x3, t3x3, t3x3,    u, t1x2]
      ])

      expect(grid.swapWithTilesAt(t2x2, 0, 3)).toBe(false)
      expect(grid.swapWithTilesAt(t2x2, 1, 3)).toBe(false)

      expect(grid.swapWithTilesAt(t1x1, 4, 3)).toBe(false)
      expect(grid.swapWithTilesAt(t1x1, 4, 4)).toBe(true)
      expect(grid.grid).toLookLike([
        [t1x2, t2x2, t2x2,    u,    u]
        [t1x2, t2x2, t2x2,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u, t1x1]
      ])

      expect(grid.swapWithTilesAt(t3x3, 0, 0)).toBe(false)
      grid.insertAt(t3x3, 0, 3)
      expect(grid.swapWithTilesAt(t3x3, 0, 0)).toBe(true)
      expect(grid.grid).toLookLike([
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t3x3, t3x3, t3x3,    u,    u]
        [t1x2, t2x2, t2x2,    u,    u]
        [t1x2, t2x2, t2x2,    u, t1x1]
      ])

      grid.insertAt(t1x1, 2, 5)
      expect(grid.swapWithTilesAt(t3x3, 1, 3)).toBe(true)
      expect(grid.grid).toLookLike([
        [t2x2, t2x2,    u,    u]
        [t2x2, t2x2,    u,    u]
        [   u, t1x1,    u,    u]
        [t1x2, t3x3, t3x3, t3x3]
        [t1x2, t3x3, t3x3, t3x3]
        [   u, t3x3, t3x3, t3x3]
      ])
      expect(grid.swapWithTilesAt(t1x2, 0, 1)).toBe(false)

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
      expect(grid.grid).toLookLike([
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

    #expect(grid.attemptInsertAt(t1x2, 0, 0)).toBe(true)

    #expect(grid.attemptInsertAt(t1x2, -1, 0)).toBe(false)
    #expect(grid.attemptInsertAt(t1x2, 0, -1)).toBe(false)

    #expect(grid.attemptInsertAt(t1x2, 0, 2)).toBe(false)
    #expect(grid.attemptInsertAt(t1x2, 1, 4)).toBe(false)
    #expect(grid.attemptInsertAt(t1x2, 3, 0)).toBe(false)
    #expect(grid.attemptInsertAt(t1x2, 3, 1)).toBe(false)

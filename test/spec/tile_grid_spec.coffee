describe 'A TileGrid class', ->
  u = undefined
  grid = null
  matrix = null
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
    grid = new TileGrid
    matrix = grid._matrix._array2D
    t1x1 = new Tile(1, 1)
    t1x2 = new Tile(1, 2)
    t1x3 = new Tile(1, 3)
    t2x1 = new Tile(2, 1)
    t2x2 = new Tile(2, 2)
    t2x3 = new Tile(2, 3)
    t3x1 = new Tile(3, 1)
    t3x2 = new Tile(3, 2)
    t3x3 = new Tile(3, 3)

  describe '#_set', ->
    it 'sets a tile at a grid area and updates the tile.', ->


  ###
  describe '#getLowestAboveRow', ->

    it 'finds the lowest above row that the tile could shift up to', ->
      grid.insert(t1x1, 0, 0)
      expect(matrix).toLookLike([
        [t1x1]
      ])
      expect(grid.getLowestAboveRow(t1x1)).toEqual(0)

      grid.insert(t3x2, 0, 3)
      expect(matrix).toLookLike([
        [t1x1,    u,    u]
        [   u,    u,    u]
        [   u,    u,    u]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(1)

      grid.insert(t1x2, 1, 0)
      expect(matrix).toLookLike([
        [t1x1, t1x2,    u]
        [   u, t1x2,    u]
        [   u,    u,    u]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(2)

      grid.insert(t1x3, 2, 0)
      expect(matrix).toLookLike([
        [t1x1, t1x2, t1x3]
        [   u, t1x2, t1x3]
        [   u,    u, t1x3]
        [t3x2, t3x2, t3x2]
        [t3x2, t3x2, t3x2]
      ])
      expect(grid.getLowestAboveRow(t3x2)).toEqual(3)
  ###

  describe '#insert', ->
    it 'inserts a tile at a grid position', ->
      grid.insert(t1x1, 0, 0)
      expect(matrix).toLookLike([
        [t1x1]
      ])

      grid.insert(t1x2, 0, 1)
      expect(matrix).toLookLike([
        [t1x1]
        [t1x2]
        [t1x2]
      ])

      grid.insert(t2x1, 1, 0)
      expect(matrix).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2,    u,    u]
        [t1x2,    u,    u]
      ])

      grid.insert(t2x2, 1, 1)
      expect(matrix).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2, t2x2, t2x2]
        [t1x2, t2x2, t2x2]
      ])

      grid.insert(t3x3, 0, 3)
      expect(matrix).toLookLike([
        [t1x1, t2x1, t2x1]
        [t1x2, t2x2, t2x2]
        [t1x2, t2x2, t2x2]
        [t3x3, t3x3, t3x3]
        [t3x3, t3x3, t3x3]
        [t3x3, t3x3, t3x3]
      ])

      # Shift all tiles 3 columns right.
      grid.insert(t1x1, 3, 0)
      grid.insert(t1x2, 3, 1)
      grid.insert(t2x1, 4, 0)
      grid.insert(t2x2, 4, 1)
      grid.insert(t3x3, 3, 3)
      expect(matrix).toLookLike([
        [   u,    u,    u, t1x1, t2x1, t2x1]
        [   u,    u,    u, t1x2, t2x2, t2x2]
        [   u,    u,    u, t1x2, t2x2, t2x2]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
        [   u,    u,    u, t3x3, t3x3, t3x3]
      ])

    describe 'when a collision occurs', ->

      it 'shifts the obstructing tiles down', ->
        grid.insert(t3x1, 0, 2)
        grid.insert(t1x1, 0, 0)
        grid.insert(t2x1, 0, 0)
        expect(matrix).toLookLike([
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insert(t1x2, 1, 0)
        expect(matrix).toLookLike([
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insert(t2x3, 0, 0)
        expect(matrix).toLookLike([
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [t2x3, t2x3,    u]
          [   u, t1x2,    u]
          [   u, t1x2,    u]
          [t2x1, t2x1,    u]
          [t1x1,    u,    u]
          [t3x1, t3x1, t3x1]
        ])

        grid.insert(t2x2, 0, 0)
        expect(matrix).toLookLike([
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

        grid.insert(t2x2, 0, 3)
        expect(matrix).toLookLike([
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

        grid.insert(t2x2, 0, 7)
        expect(matrix).toLookLike([
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

  describe '#floatUp', ->

    it 'moves a tile upwards until it encounters a barrier', ->
      grid.insert(t1x1, 0, 1)
      expect(matrix).toLookLike([
        [   u]
        [t1x1]
      ])
      grid.floatUp(t1x1)
      expect(matrix).toLookLike([
        [t1x1]
      ])

      grid.insert(t2x2, 0, 4)
      expect(matrix).toLookLike([
        [t1x1,    u]
        [   u,    u]
        [   u,    u]
        [   u,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])
      grid.floatUp(t2x2)
      expect(matrix).toLookLike([
        [t1x1,    u]
        [t2x2, t2x2]
        [t2x2, t2x2]
      ])

      grid.insert(t3x2, 2, 4)
      expect(matrix).toLookLike([
        [t1x1,    u,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u,    u, t3x2, t3x2, t3x2]
        [   u,    u, t3x2, t3x2, t3x2]
      ])
      grid.floatUp(t3x2)
      expect(matrix).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
      ])

      grid.insert(t2x1, 1, 4)
      expect(matrix).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u,    u,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])
      grid.floatUp(t2x1)
      expect(matrix).toLookLike([
        [t1x1,    u, t3x2, t3x2, t3x2]
        [t2x2, t2x2, t3x2, t3x2, t3x2]
        [t2x2, t2x2,    u,    u,    u]
        [   u, t2x1, t2x1,    u,    u]
      ])

  ###
  describe '#attemptInsertAt', ->
    it 'checks if a tile can be inserted into a new position', ->
      grid.insert(t1x1, 0, 2)
      grid.insert(t1x2, 0, 0)
      grid.insert(t1x3, 3, 0)
      grid.insert(t2x1, 1, 0)
      grid.insert(t2x2, 0, 3)
      grid.insert(t2x3, 3, 3)
      grid.insert(t3x1, 0, 5)
      grid.insert(t3x2, 1, 6)
      grid.insert(t3x3, 3, 8)
      expect(matrix).toLookLike([
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
  ###

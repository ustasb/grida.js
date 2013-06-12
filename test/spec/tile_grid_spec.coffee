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

  describe 'conversion utilities', ->

    describe '#colToLeft', ->
      it 'converts a column unit to a CSS left position', ->
        expect(grid.colToLeft(-3)).toEqual(-40)
        expect(grid.colToLeft(-2)).toEqual(-25)
        expect(grid.colToLeft(-1)).toEqual(-10)
        expect(grid.colToLeft(0)).toEqual(5)
        expect(grid.colToLeft(1)).toEqual(20)
        expect(grid.colToLeft(2)).toEqual(35)
        expect(grid.colToLeft(3)).toEqual(50)

    describe '#leftToCol', ->
      it 'converts a CSS left position to a column unit', ->
        expect(grid.leftToCol(-40)).toEqual(-3)
        expect(grid.leftToCol(-25)).toEqual(-2)
        expect(grid.leftToCol(-10)).toEqual(-1)
        expect(grid.leftToCol(5)).toEqual(0)
        expect(grid.leftToCol(20)).toEqual(1)
        expect(grid.leftToCol(35)).toEqual(2)
        expect(grid.leftToCol(50)).toEqual(3)

    describe '#rowToTop', ->
      it 'converts a row unit to a CSS top position', ->
        expect(grid.rowToTop(-3)).toEqual(-90)
        expect(grid.rowToTop(-2)).toEqual(-55)
        expect(grid.rowToTop(-1)).toEqual(-20)
        expect(grid.rowToTop(0)).toEqual(15)
        expect(grid.rowToTop(1)).toEqual(50)
        expect(grid.rowToTop(2)).toEqual(85)
        expect(grid.rowToTop(3)).toEqual(120)

    describe '#topToRow', ->
      it 'converts a CSS top position to a row unit', ->
        expect(grid.topToRow(-90)).toEqual(-3)
        expect(grid.topToRow(-55)).toEqual(-2)
        expect(grid.topToRow(-20)).toEqual(-1)
        expect(grid.topToRow(15)).toEqual(0)
        expect(grid.topToRow(50)).toEqual(1)
        expect(grid.topToRow(85)).toEqual(2)
        expect(grid.topToRow(120)).toEqual(3)

    describe '#sizeToWidth', ->
      it 'converts a grid sizex to a pixel width', ->
        expect(-> grid.sizeToWidth(-1)).toThrow()

        expect(grid.sizeToWidth(0)).toEqual(0)
        expect(grid.sizeToWidth(1)).toEqual(10)
        expect(grid.sizeToWidth(2)).toEqual(25)
        expect(grid.sizeToWidth(3)).toEqual(40)

    describe '#widthToSize', ->
      it 'converts a pixel width to a grid sizex', ->
        expect(-> grid.widthToSize(-1)).toThrow()

        expect(grid.widthToSize(0)).toEqual(0)
        expect(grid.widthToSize(10)).toEqual(1)
        expect(grid.widthToSize(25)).toEqual(2)
        expect(grid.widthToSize(40)).toEqual(3)

    describe '#sizeToHeight', ->
      it 'converts a grid sizey to a pixel height', ->
        expect(-> grid.sizeToHeight(-1)).toThrow()

        expect(grid.sizeToHeight(0)).toEqual(0)
        expect(grid.sizeToHeight(1)).toEqual(20)
        expect(grid.sizeToHeight(2)).toEqual(55)
        expect(grid.sizeToHeight(3)).toEqual(90)

    describe '#heightToSize', ->
      it 'converts a pixel height to a grid sizey', ->
        expect(-> grid.heightToSize(-1)).toThrow()

        expect(grid.heightToSize(0)).toEqual(0)
        expect(grid.heightToSize(20)).toEqual(1)
        expect(grid.heightToSize(55)).toEqual(2)
        expect(grid.heightToSize(90)).toEqual(3)

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

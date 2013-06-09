describe 'A Grid class', ->
  grid = null

  beforeEach ->
    grid = new Grid(10, 20, 5, 15)

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

  describe '#set', ->

    it 'sets a grid area with an item', ->
      grid.set(1, 0, 0, 1, 1)
      expect(grid.grid).toEqual([
        [1]
      ])

      grid.set(2, 1, 0, 2, 1)
      expect(grid.grid).toEqual([
        [1, 2, 2]
      ])

      grid.set(3, 0, 1, 3, 2)
      expect(grid.grid).toEqual([
        [1, 2, 2]
        [3, 3, 3]
        [3, 3, 3]
      ])

      grid.set(4, 3, 0, 1, 3)
      expect(grid.grid).toEqual([
        [1, 2, 2, 4]
        [3, 3, 3, 4]
        [3, 3, 3, 4]
      ])

      grid.set(5, 2, 1, 2, 2)
      expect(grid.grid).toEqual([
        [1, 2, 2, 4]
        [3, 3, 5, 5]
        [3, 3, 5, 5]
      ])

    it 'sets nothing when sizex or sizey are 0', ->
      grid.set(1, 0, 0, 3, 3)
      expect(grid.grid).toEqual([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      grid.set(2, 0, 0, 3, 0)
      grid.set(2, 0, 0, 0, 3)

      expect(grid.grid).toEqual([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

    it 'throws an error if col, row, sizex or sizey are < 0', ->
      grid.set(1, 0, 0, 3, 3)
      expect(grid.grid).toEqual([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      expect(-> grid.set(2, -1,  0,  3,  0)).toThrow()
      expect(-> grid.set(2,  0, -1,  3,  0)).toThrow()
      expect(-> grid.set(2,  0,  0, -1,  0)).toThrow()
      expect(-> grid.set(2,  0,  0,  3, -1)).toThrow()

      expect(grid.grid).toEqual([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

  describe '#get', ->

    it 'gets items in a grid area, skipping duplicates', ->
      grid.set(1, 0, 0, 1, 1)
      grid.set(2, 1, 0, 2, 1)
      grid.set(3, 0, 1, 3, 2)
      grid.set(4, 3, 0, 1, 3)
      grid.set(5, 2, 1, 2, 2)
      expect(grid.grid).toEqual([
        [1, 2, 2, 4]
        [3, 3, 5, 5]
        [3, 3, 5, 5]
      ])

      items = grid.get(-1, -1, 1, 1)
      expect(items).toEqual([])

      items = grid.get(0, 0, -1, 1)
      expect(items).toEqual([])

      items = grid.get(0, 0, 1, -1)
      expect(items).toEqual([])

      items = grid.get(0, 0, 4, 1)
      expect(items).toEqual([1, 2, 4])

      items = grid.get(0, 0, 2, 2)
      expect(items).toEqual([1, 2, 3])

      items = grid.get(0, 0, 4, 3)
      expect(items).toEqual([1, 2, 4, 3, 5])

      items = grid.get(-5, -5, 10, 10)
      expect(items).toEqual([1, 2, 4, 3, 5])

      items = grid.get(1, 1, 2, 2)
      expect(items).toEqual([3, 5])

      items = grid.get(3, 0, 1, 3)
      expect(items).toEqual([4, 5])

  describe '#clear', ->
    it 'removes items in a grid area', ->
      u = undefined

      grid.set(1, 0, 0, 5, 5)
      expect(grid.grid).toEqual([
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(0, 0, 1, 1)
      grid.clear(1, 1, 1, 1)
      expect(grid.grid).toEqual([
        [u, 1, 1, 1, 1]
        [1, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(0, 0, 2, 2)
      expect(grid.grid).toEqual([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(1, 2, 4, 1)
      expect(grid.grid).toEqual([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, u, u, u, u]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(3, 0, 2, 5)
      expect(grid.grid).toEqual([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [1, 1, 1, u, u]
        [1, 1, 1, u, u]
      ])

      grid.clear(-1, 3, 7, 3)
      expect(grid.grid).toEqual([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

      grid.clear(-2, -2, 10, 10)
      expect(grid.grid).toEqual([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

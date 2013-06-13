describe 'A Grid class', ->
  u = undefined
  grid = null

  beforeEach ->
    grid = new Grid

  describe '#set', ->
    it 'sets a grid area with an item', ->
      grid.set(1, 0, 0, 1, 1)
      expect(grid.grid).toLookLike([
        [1]
      ])

      grid.set(2, 1, 0, 2, 1)
      expect(grid.grid).toLookLike([
        [1, 2, 2]
      ])

      grid.set(3, 0, 1, 3, 2)
      expect(grid.grid).toLookLike([
        [1, 2, 2]
        [3, 3, 3]
        [3, 3, 3]
      ])

      grid.set(4, 3, 0, 1, 3)
      expect(grid.grid).toLookLike([
        [1, 2, 2, 4]
        [3, 3, 3, 4]
        [3, 3, 3, 4]
      ])

      grid.set(5, 2, 1, 2, 2)
      expect(grid.grid).toLookLike([
        [1, 2, 2, 4]
        [3, 3, 5, 5]
        [3, 3, 5, 5]
      ])

      grid.set(6, 4, 0, 3, 1)
      expect(grid.grid).toLookLike([
        [1, 2, 2, 4, 6, 6, 6]
        [3, 3, 5, 5, u, u, u]
        [3, 3, 5, 5, u, u, u]
      ])

      grid.set(7, 4, 2, 3, 1)
      expect(grid.grid).toLookLike([
        [1, 2, 2, 4, 6, 6, 6]
        [3, 3, 5, 5, u, u, u]
        [3, 3, 5, 5, 7, 7, 7]
      ])

    it 'sets nothing when sizex or sizey are 0', ->
      grid.set(1, 0, 0, 3, 3)
      expect(grid.grid).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      grid.set(2, 0, 0, 3, 0)
      grid.set(2, 0, 0, 0, 3)

      expect(grid.grid).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

    it 'throws an error if col, row, sizex or sizey are < 0', ->
      grid.set(1, 0, 0, 3, 3)
      expect(grid.grid).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      expect(-> grid.set(2, -1,  0,  3,  0)).toThrow()
      expect(-> grid.set(2,  0, -1,  3,  0)).toThrow()
      expect(-> grid.set(2,  0,  0, -1,  0)).toThrow()
      expect(-> grid.set(2,  0,  0,  3, -1)).toThrow()

      expect(grid.grid).toLookLike([
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
      expect(grid.grid).toLookLike([
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

      grid.set(1, 0, 0, 5, 5)
      expect(grid.grid).toLookLike([
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(0, 0, 1, 1)
      grid.clear(1, 1, 1, 1)
      expect(grid.grid).toLookLike([
        [u, 1, 1, 1, 1]
        [1, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(0, 0, 2, 2)
      expect(grid.grid).toLookLike([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(1, 2, 4, 1)
      expect(grid.grid).toLookLike([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, u, u, u, u]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      grid.clear(3, 0, 2, 5)
      expect(grid.grid).toLookLike([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [1, 1, 1, u, u]
        [1, 1, 1, u, u]
      ])

      grid.clear(-1, 3, 7, 3)
      expect(grid.grid).toLookLike([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

      grid.clear(-2, -2, 10, 10)
      expect(grid.grid).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

    it 'only removes items equal to specificItem if defined', ->
      grid.set(0, 0, 0, 5, 5)
      grid.set(1, 1, 4, 3, 1)
      grid.set(2, 0, 1, 2, 1)
      grid.set(3, 1, 2, 3, 1)
      grid.set(4, 0, 2, 1, 3)
      grid.set(5, 2, 1, 1, 1)
      grid.set(6, 2, 0, 3, 1)
      grid.set(7, 1, 3, 1, 1)
      grid.set(8, 4, 1, 1, 4)
      grid.set(9, 2, 3, 2, 1)
      expect(grid.grid).toLookLike([
        [0, 0, 6, 6, 6]
        [2, 2, 5, 0, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, 1, 1, 1, 8]
      ])

      grid.clear(0, 0, 5, 5, 0)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [2, 2, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, 1, 1, 1, 8]
      ])

      grid.clear(0, 0, 5, 5, 1)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [2, 2, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 2)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 3)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [4, u, u, u, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 4)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 5)
      expect(grid.grid).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 6)
      expect(grid.grid).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 7)
      expect(grid.grid).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, u, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      grid.clear(0, 0, 5, 5, 8)
      expect(grid.grid).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, 9, 9, u]
        [u, u, u, u, u]
      ])

      grid.clear(0, 0, 5, 5, 9)
      expect(grid.grid).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

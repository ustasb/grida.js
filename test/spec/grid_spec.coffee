describe 'A Matrix2D class', ->
  u = undefined
  mat = null

  beforeEach ->
    mat = new Matrix2D

  describe '#set', ->
    it 'sets a matrix area with an item', ->
      mat.set(1, 0, 0, 1, 1)
      expect(mat._array2D).toLookLike([
        [1]
      ])

      mat.set(2, 1, 0, 2, 1)
      expect(mat._array2D).toLookLike([
        [1, 2, 2]
      ])

      mat.set(3, 0, 1, 3, 2)
      expect(mat._array2D).toLookLike([
        [1, 2, 2]
        [3, 3, 3]
        [3, 3, 3]
      ])

      mat.set(4, 3, 0, 1, 3)
      expect(mat._array2D).toLookLike([
        [1, 2, 2, 4]
        [3, 3, 3, 4]
        [3, 3, 3, 4]
      ])

      mat.set(5, 2, 1, 2, 2)
      expect(mat._array2D).toLookLike([
        [1, 2, 2, 4]
        [3, 3, 5, 5]
        [3, 3, 5, 5]
      ])

      mat.set(6, 4, 0, 3, 1)
      expect(mat._array2D).toLookLike([
        [1, 2, 2, 4, 6, 6, 6]
        [3, 3, 5, 5, u, u, u]
        [3, 3, 5, 5, u, u, u]
      ])

      mat.set(7, 4, 2, 3, 1)
      expect(mat._array2D).toLookLike([
        [1, 2, 2, 4, 6, 6, 6]
        [3, 3, 5, 5, u, u, u]
        [3, 3, 5, 5, 7, 7, 7]
      ])

    it 'sets nothing when sizex or sizey are 0', ->
      mat.set(1, 0, 0, 3, 3)
      expect(mat._array2D).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      mat.set(2, 0, 0, 3, 0)
      mat.set(2, 0, 0, 0, 3)

      expect(mat._array2D).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

    it 'throws an error if col, row, sizex or sizey are < 0', ->
      mat.set(1, 0, 0, 3, 3)
      expect(mat._array2D).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

      expect(-> mat.set(2, -1,  0,  3,  0)).toThrow()
      expect(-> mat.set(2,  0, -1,  3,  0)).toThrow()
      expect(-> mat.set(2,  0,  0, -1,  0)).toThrow()
      expect(-> mat.set(2,  0,  0,  3, -1)).toThrow()

      expect(mat._array2D).toLookLike([
        [1, 1, 1]
        [1, 1, 1]
        [1, 1, 1]
      ])

  describe '#get', ->
    it 'gets items in a matrix area, skipping duplicates', ->
      mat.set(1, 0, 0, 1, 1)
      mat.set(2, 1, 0, 2, 1)
      mat.set(3, 0, 1, 3, 2)
      mat.set(4, 3, 0, 1, 3)
      mat.set(5, 2, 1, 2, 2)
      expect(mat._array2D).toLookLike([
        [1, 2, 2, 4]
        [3, 3, 5, 5]
        [3, 3, 5, 5]
      ])

      items = mat.get(-1, -1, 1, 1)
      expect(items).toEqual([])

      items = mat.get(0, 0, 0, 0)
      expect(items).toEqual([])

      items = mat.get(0, 0, 1, 0)
      expect(items).toEqual([])

      items = mat.get(0, 0, 0, 1)
      expect(items).toEqual([])

      items = mat.get(0, 0, -1, 1)
      expect(items).toEqual([])

      items = mat.get(0, 0, 1, -1)
      expect(items).toEqual([])

      items = mat.get(0, 0, 1, 1)
      expect(items).toEqual([1])

      items = mat.get(0, 0, 4, 1)
      expect(items).toEqual([1, 2, 4])

      items = mat.get(0, 0, 2, 2)
      expect(items).toEqual([1, 2, 3])

      items = mat.get(0, 0, 4, 3)
      expect(items).toEqual([1, 2, 4, 3, 5])

      items = mat.get(-5, -5, 10, 10)
      expect(items).toEqual([1, 2, 4, 3, 5])

      items = mat.get(1, 1, 2, 2)
      expect(items).toEqual([3, 5])

      items = mat.get(3, 0, 1, 3)
      expect(items).toEqual([4, 5])

  describe '#clear', ->
    it 'removes items in a matrix area', ->

      mat.set(1, 0, 0, 5, 5)
      expect(mat._array2D).toLookLike([
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      mat.clear(0, 0, 1, 1)
      mat.clear(1, 1, 1, 1)
      expect(mat._array2D).toLookLike([
        [u, 1, 1, 1, 1]
        [1, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      mat.clear(0, 0, 2, 2)
      expect(mat._array2D).toLookLike([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      mat.clear(1, 2, 4, 1)
      expect(mat._array2D).toLookLike([
        [u, u, 1, 1, 1]
        [u, u, 1, 1, 1]
        [1, u, u, u, u]
        [1, 1, 1, 1, 1]
        [1, 1, 1, 1, 1]
      ])

      mat.clear(3, 0, 2, 5)
      expect(mat._array2D).toLookLike([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [1, 1, 1, u, u]
        [1, 1, 1, u, u]
      ])

      mat.clear(-1, 3, 7, 3)
      expect(mat._array2D).toLookLike([
        [u, u, 1, u, u]
        [u, u, 1, u, u]
        [1, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

      mat.clear(-2, -2, 10, 10)
      expect(mat._array2D).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

    it 'only removes items equal to filterItem if defined', ->
      mat.set(0, 0, 0, 5, 5)
      mat.set(1, 1, 4, 3, 1)
      mat.set(2, 0, 1, 2, 1)
      mat.set(3, 1, 2, 3, 1)
      mat.set(4, 0, 2, 1, 3)
      mat.set(5, 2, 1, 1, 1)
      mat.set(6, 2, 0, 3, 1)
      mat.set(7, 1, 3, 1, 1)
      mat.set(8, 4, 1, 1, 4)
      mat.set(9, 2, 3, 2, 1)
      expect(mat._array2D).toLookLike([
        [0, 0, 6, 6, 6]
        [2, 2, 5, 0, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, 1, 1, 1, 8]
      ])

      mat.clear(0, 0, 5, 5, 0)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [2, 2, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, 1, 1, 1, 8]
      ])

      mat.clear(0, 0, 5, 5, 1)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [2, 2, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 2)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [4, 3, 3, 3, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 3)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [4, u, u, u, 8]
        [4, 7, 9, 9, 8]
        [4, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 4)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, 5, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 5)
      expect(mat._array2D).toLookLike([
        [u, u, 6, 6, 6]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 6)
      expect(mat._array2D).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, 7, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 7)
      expect(mat._array2D).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, 8]
        [u, u, u, u, 8]
        [u, u, 9, 9, 8]
        [u, u, u, u, 8]
      ])

      mat.clear(0, 0, 5, 5, 8)
      expect(mat._array2D).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, 9, 9, u]
        [u, u, u, u, u]
      ])

      mat.clear(0, 0, 5, 5, 9)
      expect(mat._array2D).toLookLike([
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
        [u, u, u, u, u]
      ])

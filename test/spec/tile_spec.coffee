describe 'A Tile class', ->
  GRID = 'grid'
  tile = undefined

  beforeEach -> tile = new Tile

  describe '#setPos', ->
    it 'sets the @grid, @col and @row attributes', ->
      tile.setPos(GRID, 1, 2)
      expect(tile.grid).toBe(GRID)
      expect(tile.col).toBe(1)
      expect(tile.row).toBe(2)

    it 'nulls the @col and @row attributes if @grid is null', ->
      tile.setPos(null)
      expect(tile.grid).toBe(null)
      expect(tile.col).toBe(null)
      expect(tile.row).toBe(null)

  describe '#setSize', ->
    it 'sets the @sizex and @sizey attributes', ->
      tile.setSize(1, 2)
      expect(tile.sizex).toBe(1)
      expect(tile.sizey).toBe(2)

    it 'throws an error if a size is <= 0', ->
      expect(-> tile.setSize(0, 0) ).toThrow()
      expect(-> tile.setSize(1, 0) ).toThrow()
      expect(-> tile.setSize(0, 1) ).toThrow()
      expect(-> tile.setSize(-1, 1) ).toThrow()
      expect(-> tile.setSize(1, -1) ).toThrow()

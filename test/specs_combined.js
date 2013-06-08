(function() {
  describe('A Grid class', function() {
    var grid;
    grid = null;
    beforeEach(function() {
      return grid = new Grid(10, 10, 5, 5);
    });
    describe('#set', function() {
      it('sets a grid area with an item', function() {
        grid.set(1, 0, 0, 1, 1);
        expect(grid.grid).toEqual([[1]]);
        grid.set(2, 1, 0, 2, 1);
        expect(grid.grid).toEqual([[1, 2, 2]]);
        grid.set(3, 0, 1, 3, 2);
        expect(grid.grid).toEqual([[1, 2, 2], [3, 3, 3], [3, 3, 3]]);
        grid.set(4, 3, 0, 1, 3);
        expect(grid.grid).toEqual([[1, 2, 2, 4], [3, 3, 3, 4], [3, 3, 3, 4]]);
        grid.set(5, 2, 1, 2, 2);
        return expect(grid.grid).toEqual([[1, 2, 2, 4], [3, 3, 5, 5], [3, 3, 5, 5]]);
      });
      it('sets nothing when sizex or sizey are 0', function() {
        grid.set(1, 0, 0, 3, 3);
        expect(grid.grid).toEqual([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
        grid.set(2, 0, 0, 3, 0);
        grid.set(2, 0, 0, 0, 3);
        return expect(grid.grid).toEqual([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
      });
      return it('throws an error if col, row, sizex or sizey are < 0', function() {
        grid.set(1, 0, 0, 3, 3);
        expect(grid.grid).toEqual([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
        expect(function() {
          return grid.set(2, -1, 0, 3, 0);
        }).toThrow();
        expect(function() {
          return grid.set(2, 0, -1, 3, 0);
        }).toThrow();
        expect(function() {
          return grid.set(2, 0, 0, -1, 0);
        }).toThrow();
        expect(function() {
          return grid.set(2, 0, 0, 3, -1);
        }).toThrow();
        return expect(grid.grid).toEqual([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
      });
    });
    return describe('#get', function() {
      return it('gets items in a grid area, skipping duplicates', function() {
        var items;
        grid.set(1, 0, 0, 1, 1);
        grid.set(2, 1, 0, 2, 1);
        grid.set(3, 0, 1, 3, 2);
        grid.set(4, 3, 0, 1, 3);
        grid.set(5, 2, 1, 2, 2);
        expect(grid.grid).toEqual([[1, 2, 2, 4], [3, 3, 5, 5], [3, 3, 5, 5]]);
        items = grid.get(-1, -1, 1, 1);
        expect(items).toEqual([]);
        items = grid.get(0, 0, -1, 1);
        expect(items).toEqual([]);
        items = grid.get(0, 0, 1, -1);
        expect(items).toEqual([]);
        items = grid.get(0, 0, 4, 1);
        expect(items).toEqual([1, 2, 4]);
        items = grid.get(0, 0, 2, 2);
        expect(items).toEqual([1, 2, 3]);
        items = grid.get(0, 0, 4, 3);
        expect(items).toEqual([1, 2, 4, 3, 5]);
        items = grid.get(-5, -5, 10, 10);
        expect(items).toEqual([1, 2, 4, 3, 5]);
        items = grid.get(1, 1, 2, 2);
        expect(items).toEqual([3, 5]);
        items = grid.get(3, 0, 1, 3);
        return expect(items).toEqual([4, 5]);
      });
    });
  });

}).call(this);

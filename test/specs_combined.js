(function() {
  describe('A Grid class', function() {
    var grid;
    grid = null;
    beforeEach(function() {
      return grid = new Grid;
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
    describe('#get', function() {
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
    return describe('#clear', function() {
      return it('removes items in a grid area', function() {
        var u;
        u = void 0;
        grid.set(1, 0, 0, 5, 5);
        expect(grid.grid).toEqual([[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        grid.clear(0, 0, 1, 1);
        grid.clear(1, 1, 1, 1);
        expect(grid.grid).toEqual([[u, 1, 1, 1, 1], [1, u, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        grid.clear(0, 0, 2, 2);
        expect(grid.grid).toEqual([[u, u, 1, 1, 1], [u, u, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        grid.clear(1, 2, 4, 1);
        expect(grid.grid).toEqual([[u, u, 1, 1, 1], [u, u, 1, 1, 1], [1, u, u, u, u], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        grid.clear(3, 0, 2, 5);
        expect(grid.grid).toEqual([[u, u, 1, u, u], [u, u, 1, u, u], [1, u, u, u, u], [1, 1, 1, u, u], [1, 1, 1, u, u]]);
        grid.clear(-1, 3, 7, 3);
        expect(grid.grid).toEqual([[u, u, 1, u, u], [u, u, 1, u, u], [1, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u]]);
        grid.clear(-2, -2, 10, 10);
        return expect(grid.grid).toEqual([[u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u]]);
      });
    });
  });

}).call(this);

(function() {
  describe('A TileGrid class', function() {
    var grid;
    grid = null;
    return describe('conversion utilities', function() {
      beforeEach(function() {
        return grid = new TileGrid(10, 20, 5, 15);
      });
      describe('#colToLeft', function() {
        return it('converts a column unit to a CSS left position', function() {
          expect(grid.colToLeft(-3)).toEqual(-40);
          expect(grid.colToLeft(-2)).toEqual(-25);
          expect(grid.colToLeft(-1)).toEqual(-10);
          expect(grid.colToLeft(0)).toEqual(5);
          expect(grid.colToLeft(1)).toEqual(20);
          expect(grid.colToLeft(2)).toEqual(35);
          return expect(grid.colToLeft(3)).toEqual(50);
        });
      });
      describe('#leftToCol', function() {
        return it('converts a CSS left position to a column unit', function() {
          expect(grid.leftToCol(-40)).toEqual(-3);
          expect(grid.leftToCol(-25)).toEqual(-2);
          expect(grid.leftToCol(-10)).toEqual(-1);
          expect(grid.leftToCol(5)).toEqual(0);
          expect(grid.leftToCol(20)).toEqual(1);
          expect(grid.leftToCol(35)).toEqual(2);
          return expect(grid.leftToCol(50)).toEqual(3);
        });
      });
      describe('#rowToTop', function() {
        return it('converts a row unit to a CSS top position', function() {
          expect(grid.rowToTop(-3)).toEqual(-90);
          expect(grid.rowToTop(-2)).toEqual(-55);
          expect(grid.rowToTop(-1)).toEqual(-20);
          expect(grid.rowToTop(0)).toEqual(15);
          expect(grid.rowToTop(1)).toEqual(50);
          expect(grid.rowToTop(2)).toEqual(85);
          return expect(grid.rowToTop(3)).toEqual(120);
        });
      });
      describe('#topToRow', function() {
        return it('converts a CSS top position to a row unit', function() {
          expect(grid.topToRow(-90)).toEqual(-3);
          expect(grid.topToRow(-55)).toEqual(-2);
          expect(grid.topToRow(-20)).toEqual(-1);
          expect(grid.topToRow(15)).toEqual(0);
          expect(grid.topToRow(50)).toEqual(1);
          expect(grid.topToRow(85)).toEqual(2);
          return expect(grid.topToRow(120)).toEqual(3);
        });
      });
      describe('#sizeToWidth', function() {
        return it('converts a grid sizex to a pixel width', function() {
          expect(function() {
            return grid.sizeToWidth(-1);
          }).toThrow();
          expect(grid.sizeToWidth(0)).toEqual(0);
          expect(grid.sizeToWidth(1)).toEqual(10);
          expect(grid.sizeToWidth(2)).toEqual(25);
          return expect(grid.sizeToWidth(3)).toEqual(40);
        });
      });
      describe('#widthToSize', function() {
        return it('converts a pixel width to a grid sizex', function() {
          expect(function() {
            return grid.widthToSize(-1);
          }).toThrow();
          expect(grid.widthToSize(0)).toEqual(0);
          expect(grid.widthToSize(10)).toEqual(1);
          expect(grid.widthToSize(25)).toEqual(2);
          return expect(grid.widthToSize(40)).toEqual(3);
        });
      });
      describe('#sizeToHeight', function() {
        return it('converts a grid sizey to a pixel height', function() {
          expect(function() {
            return grid.sizeToHeight(-1);
          }).toThrow();
          expect(grid.sizeToHeight(0)).toEqual(0);
          expect(grid.sizeToHeight(1)).toEqual(20);
          expect(grid.sizeToHeight(2)).toEqual(55);
          return expect(grid.sizeToHeight(3)).toEqual(90);
        });
      });
      describe('#heightToSize', function() {
        return it('converts a pixel height to a grid sizey', function() {
          expect(function() {
            return grid.heightToSize(-1);
          }).toThrow();
          expect(grid.heightToSize(0)).toEqual(0);
          expect(grid.heightToSize(20)).toEqual(1);
          expect(grid.heightToSize(55)).toEqual(2);
          return expect(grid.heightToSize(90)).toEqual(3);
        });
      });
      return describe('#insertAt', function() {
        var t1x1, t1x2, t1x3, t2x1, t2x2, t2x3, t3x1, t3x2, t3x3;
        grid = null;
        t1x1 = null;
        t1x2 = null;
        t1x3 = null;
        t2x1 = null;
        t2x2 = null;
        t2x3 = null;
        t3x1 = null;
        t3x2 = null;
        t3x3 = null;
        beforeEach(function() {
          grid = new TileGrid(10, 20, 5, 15);
          t1x1 = new Tile(grid, 1, 1);
          t1x2 = new Tile(grid, 1, 2);
          t1x3 = new Tile(grid, 1, 3);
          t2x1 = new Tile(grid, 2, 1);
          t2x2 = new Tile(grid, 2, 2);
          t2x3 = new Tile(grid, 2, 3);
          t3x1 = new Tile(grid, 3, 1);
          t3x2 = new Tile(grid, 3, 2);
          return t3x3 = new Tile(grid, 3, 3);
        });
        return it('inserts a tile at a grid position', function() {});
      });
    });
  });

}).call(this);

(function() {
  describe('A tile class', function() {
    var grid;
    grid = null;
    beforeEach(function() {
      return grid = new Grid(10, 20, 5, 15);
    });
    return describe('#moveTo', function() {});
  });

}).call(this);

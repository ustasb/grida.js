(function() {
  beforeEach(function() {
    return this.addMatchers({
      toLookLike: (function() {
        var looksLike;
        looksLike = function(a, b) {
          var item, row, x, y, _i, _j, _len, _len1;
          for (y = _i = 0, _len = a.length; _i < _len; y = _i += 1) {
            row = a[y];
            if (row != null) {
              for (x = _j = 0, _len1 = row.length; _j < _len1; x = _j += 1) {
                item = row[x];
                if ((item != null) && ((b[y] != null) === false || item !== b[y][x])) {
                  return false;
                }
              }
            }
          }
          return true;
        };
        return function(expected) {
          if (!$.isArray(this.actual) || !$.isArray(expected)) {
            throw 'Matcher toLookLike() can only compare arrays.';
          }
          return looksLike(this.actual, expected) && looksLike(expected, this.actual);
        };
      })()
    });
  });

}).call(this);

(function() {
  describe('A DOMTileGrid class', function() {
    var $container, grid;
    grid = null;
    $container = $(document.createElement('div'));
    beforeEach(function() {
      return grid = new DOMTileGrid($container, 10, 20, 5, 15);
    });
    describe('conversion utilities', function() {
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
          expect(grid.sizeToWidth(-1)).toEqual(0);
          expect(grid.sizeToWidth(0)).toEqual(0);
          expect(grid.sizeToWidth(1)).toEqual(10);
          expect(grid.sizeToWidth(2)).toEqual(25);
          return expect(grid.sizeToWidth(3)).toEqual(40);
        });
      });
      describe('#widthToSize', function() {
        return it('converts a pixel width to a grid sizex', function() {
          expect(grid.widthToSize(-1)).toEqual(0);
          expect(grid.widthToSize(0)).toEqual(0);
          expect(grid.widthToSize(10)).toEqual(1);
          expect(grid.widthToSize(25)).toEqual(2);
          return expect(grid.widthToSize(40)).toEqual(3);
        });
      });
      describe('#sizeToHeight', function() {
        return it('converts a grid sizey to a pixel height', function() {
          expect(grid.sizeToHeight(-1)).toEqual(0);
          expect(grid.sizeToHeight(0)).toEqual(0);
          expect(grid.sizeToHeight(1)).toEqual(20);
          expect(grid.sizeToHeight(2)).toEqual(55);
          return expect(grid.sizeToHeight(3)).toEqual(90);
        });
      });
      return describe('#heightToSize', function() {
        return it('converts a pixel height to a grid sizey', function() {
          expect(grid.heightToSize(-1)).toEqual(0);
          expect(grid.heightToSize(0)).toEqual(0);
          expect(grid.heightToSize(20)).toEqual(1);
          expect(grid.heightToSize(55)).toEqual(2);
          return expect(grid.heightToSize(90)).toEqual(3);
        });
      });
    });
    describe('#getMaxCol', function() {
      return it("calculates the container's maximum column", function() {
        $container.width(0);
        expect(grid.getMaxCol()).toEqual(0);
        $container.width(5);
        expect(grid.getMaxCol()).toEqual(0);
        $container.width(20);
        expect(grid.getMaxCol()).toEqual(0);
        $container.width(35);
        expect(grid.getMaxCol()).toEqual(1);
        $container.width(100);
        expect(grid.getMaxCol()).toEqual(5);
        $container.width(500);
        return expect(grid.getMaxCol()).toEqual(32);
      });
    });
    return describe('#getCenteringOffset', function() {
      return it('calculates left offset required to center the grid', function() {
        $container.width(0);
        expect(grid.getCenteringOffset()).toEqual(0);
        $container.width(5);
        expect(grid.getCenteringOffset()).toEqual(0);
        $container.width(20);
        expect(grid.getCenteringOffset()).toEqual(0);
        $container.width(22);
        expect(grid.getCenteringOffset()).toEqual(1);
        $container.width(30);
        expect(grid.getCenteringOffset()).toEqual(5);
        $container.width(35);
        expect(grid.getCenteringOffset()).toEqual(0);
        $container.width(100);
        expect(grid.getCenteringOffset()).toEqual(2.5);
        $container.width(500);
        return expect(grid.getCenteringOffset()).toEqual(0);
      });
    });
  });

}).call(this);

(function() {
  describe('A Matrix2D class', function() {
    var mat, u;
    u = void 0;
    mat = null;
    beforeEach(function() {
      return mat = new Matrix2D;
    });
    describe('#set', function() {
      it('sets a matrix area with an item', function() {
        mat.set(1, 0, 0, 1, 1);
        expect(mat._array2D).toLookLike([[1]]);
        mat.set(2, 1, 0, 2, 1);
        expect(mat._array2D).toLookLike([[1, 2, 2]]);
        mat.set(3, 0, 1, 3, 2);
        expect(mat._array2D).toLookLike([[1, 2, 2], [3, 3, 3], [3, 3, 3]]);
        mat.set(4, 3, 0, 1, 3);
        expect(mat._array2D).toLookLike([[1, 2, 2, 4], [3, 3, 3, 4], [3, 3, 3, 4]]);
        mat.set(5, 2, 1, 2, 2);
        expect(mat._array2D).toLookLike([[1, 2, 2, 4], [3, 3, 5, 5], [3, 3, 5, 5]]);
        mat.set(6, 4, 0, 3, 1);
        expect(mat._array2D).toLookLike([[1, 2, 2, 4, 6, 6, 6], [3, 3, 5, 5, u, u, u], [3, 3, 5, 5, u, u, u]]);
        mat.set(7, 4, 2, 3, 1);
        return expect(mat._array2D).toLookLike([[1, 2, 2, 4, 6, 6, 6], [3, 3, 5, 5, u, u, u], [3, 3, 5, 5, 7, 7, 7]]);
      });
      it('sets nothing when sizex or sizey are 0', function() {
        mat.set(1, 0, 0, 3, 3);
        expect(mat._array2D).toLookLike([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
        mat.set(2, 0, 0, 3, 0);
        mat.set(2, 0, 0, 0, 3);
        return expect(mat._array2D).toLookLike([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
      });
      return it('throws an error if col, row, sizex or sizey are < 0', function() {
        mat.set(1, 0, 0, 3, 3);
        expect(mat._array2D).toLookLike([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
        expect(function() {
          return mat.set(2, -1, 0, 3, 0);
        }).toThrow();
        expect(function() {
          return mat.set(2, 0, -1, 3, 0);
        }).toThrow();
        expect(function() {
          return mat.set(2, 0, 0, -1, 0);
        }).toThrow();
        expect(function() {
          return mat.set(2, 0, 0, 3, -1);
        }).toThrow();
        return expect(mat._array2D).toLookLike([[1, 1, 1], [1, 1, 1], [1, 1, 1]]);
      });
    });
    describe('#get', function() {
      return it('gets items in a matrix area, skipping duplicates', function() {
        var items;
        mat.set(1, 0, 0, 1, 1);
        mat.set(2, 1, 0, 2, 1);
        mat.set(3, 0, 1, 3, 2);
        mat.set(4, 3, 0, 1, 3);
        mat.set(5, 2, 1, 2, 2);
        expect(mat._array2D).toLookLike([[1, 2, 2, 4], [3, 3, 5, 5], [3, 3, 5, 5]]);
        items = mat.get(-1, -1, 1, 1);
        expect(items).toEqual([]);
        items = mat.get(0, 0, 0, 0);
        expect(items).toEqual([]);
        items = mat.get(0, 0, 1, 0);
        expect(items).toEqual([]);
        items = mat.get(0, 0, 0, 1);
        expect(items).toEqual([]);
        items = mat.get(0, 0, -1, 1);
        expect(items).toEqual([]);
        items = mat.get(0, 0, 1, -1);
        expect(items).toEqual([]);
        items = mat.get(0, 0, 1, 1);
        expect(items).toEqual([1]);
        items = mat.get(0, 0, 4, 1);
        expect(items).toEqual([1, 2, 4]);
        items = mat.get(0, 0, 2, 2);
        expect(items).toEqual([1, 2, 3]);
        items = mat.get(0, 0, 4, 3);
        expect(items).toEqual([1, 2, 4, 3, 5]);
        items = mat.get(-5, -5, 10, 10);
        expect(items).toEqual([1, 2, 4, 3, 5]);
        items = mat.get(1, 1, 2, 2);
        expect(items).toEqual([3, 5]);
        items = mat.get(3, 0, 1, 3);
        return expect(items).toEqual([4, 5]);
      });
    });
    return describe('#clear', function() {
      it('removes items in a matrix area', function() {
        mat.set(1, 0, 0, 5, 5);
        expect(mat._array2D).toLookLike([[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        mat.clear(0, 0, 1, 1);
        mat.clear(1, 1, 1, 1);
        expect(mat._array2D).toLookLike([[u, 1, 1, 1, 1], [1, u, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        mat.clear(0, 0, 2, 2);
        expect(mat._array2D).toLookLike([[u, u, 1, 1, 1], [u, u, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        mat.clear(1, 2, 4, 1);
        expect(mat._array2D).toLookLike([[u, u, 1, 1, 1], [u, u, 1, 1, 1], [1, u, u, u, u], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]);
        mat.clear(3, 0, 2, 5);
        expect(mat._array2D).toLookLike([[u, u, 1, u, u], [u, u, 1, u, u], [1, u, u, u, u], [1, 1, 1, u, u], [1, 1, 1, u, u]]);
        mat.clear(-1, 3, 7, 3);
        expect(mat._array2D).toLookLike([[u, u, 1, u, u], [u, u, 1, u, u], [1, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u]]);
        mat.clear(-2, -2, 10, 10);
        return expect(mat._array2D).toLookLike([[u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u]]);
      });
      return it('only removes items equal to targetItem if defined', function() {
        mat.set(0, 0, 0, 5, 5);
        mat.set(1, 1, 4, 3, 1);
        mat.set(2, 0, 1, 2, 1);
        mat.set(3, 1, 2, 3, 1);
        mat.set(4, 0, 2, 1, 3);
        mat.set(5, 2, 1, 1, 1);
        mat.set(6, 2, 0, 3, 1);
        mat.set(7, 1, 3, 1, 1);
        mat.set(8, 4, 1, 1, 4);
        mat.set(9, 2, 3, 2, 1);
        expect(mat._array2D).toLookLike([[0, 0, 6, 6, 6], [2, 2, 5, 0, 8], [4, 3, 3, 3, 8], [4, 7, 9, 9, 8], [4, 1, 1, 1, 8]]);
        mat.clear(0, 0, 5, 5, 0);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [2, 2, 5, u, 8], [4, 3, 3, 3, 8], [4, 7, 9, 9, 8], [4, 1, 1, 1, 8]]);
        mat.clear(0, 0, 5, 5, 1);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [2, 2, 5, u, 8], [4, 3, 3, 3, 8], [4, 7, 9, 9, 8], [4, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 2);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [u, u, 5, u, 8], [4, 3, 3, 3, 8], [4, 7, 9, 9, 8], [4, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 3);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [u, u, 5, u, 8], [4, u, u, u, 8], [4, 7, 9, 9, 8], [4, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 4);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [u, u, 5, u, 8], [u, u, u, u, 8], [u, 7, 9, 9, 8], [u, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 5);
        expect(mat._array2D).toLookLike([[u, u, 6, 6, 6], [u, u, u, u, 8], [u, u, u, u, 8], [u, 7, 9, 9, 8], [u, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 6);
        expect(mat._array2D).toLookLike([[u, u, u, u, u], [u, u, u, u, 8], [u, u, u, u, 8], [u, 7, 9, 9, 8], [u, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 7);
        expect(mat._array2D).toLookLike([[u, u, u, u, u], [u, u, u, u, 8], [u, u, u, u, 8], [u, u, 9, 9, 8], [u, u, u, u, 8]]);
        mat.clear(0, 0, 5, 5, 8);
        expect(mat._array2D).toLookLike([[u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, 9, 9, u], [u, u, u, u, u]]);
        mat.clear(0, 0, 5, 5, 9);
        return expect(mat._array2D).toLookLike([[u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u], [u, u, u, u, u]]);
      });
    });
  });

}).call(this);

(function() {
  describe('A TileGrid class', function() {
    var grid, matrix, t1x1, t1x2, t1x3, t2x1, t2x2, t2x3, t3x1, t3x2, t3x3, u;
    u = void 0;
    grid = null;
    matrix = null;
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
      grid = new TileGrid;
      matrix = grid._matrix._array2D;
      t1x1 = new Tile(1, 1);
      t1x2 = new Tile(1, 2);
      t1x3 = new Tile(1, 3);
      t2x1 = new Tile(2, 1);
      t2x2 = new Tile(2, 2);
      t2x3 = new Tile(2, 3);
      t3x1 = new Tile(3, 1);
      t3x2 = new Tile(3, 2);
      return t3x3 = new Tile(3, 3);
    });
    describe('#_set', function() {
      return it('sets a tile at a grid area and updates the tile.', function() {});
    });
    /*
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
    */

    describe('#insert', function() {
      it('inserts a tile at a grid position', function() {
        grid.insert(t1x1, 0, 0);
        expect(matrix).toLookLike([[t1x1]]);
        grid.insert(t1x2, 0, 1);
        expect(matrix).toLookLike([[t1x1], [t1x2], [t1x2]]);
        grid.insert(t2x1, 1, 0);
        expect(matrix).toLookLike([[t1x1, t2x1, t2x1], [t1x2, u, u], [t1x2, u, u]]);
        grid.insert(t2x2, 1, 1);
        expect(matrix).toLookLike([[t1x1, t2x1, t2x1], [t1x2, t2x2, t2x2], [t1x2, t2x2, t2x2]]);
        grid.insert(t3x3, 0, 3);
        expect(matrix).toLookLike([[t1x1, t2x1, t2x1], [t1x2, t2x2, t2x2], [t1x2, t2x2, t2x2], [t3x3, t3x3, t3x3], [t3x3, t3x3, t3x3], [t3x3, t3x3, t3x3]]);
        grid.insert(t1x1, 3, 0);
        grid.insert(t1x2, 3, 1);
        grid.insert(t2x1, 4, 0);
        grid.insert(t2x2, 4, 1);
        grid.insert(t3x3, 3, 3);
        return expect(matrix).toLookLike([[u, u, u, t1x1, t2x1, t2x1], [u, u, u, t1x2, t2x2, t2x2], [u, u, u, t1x2, t2x2, t2x2], [u, u, u, t3x3, t3x3, t3x3], [u, u, u, t3x3, t3x3, t3x3], [u, u, u, t3x3, t3x3, t3x3]]);
      });
      return describe('when a collision occurs', function() {
        return it('shifts the obstructing tiles down', function() {
          grid.insert(t3x1, 0, 2);
          grid.insert(t1x1, 0, 0);
          grid.insert(t2x1, 0, 0);
          expect(matrix).toLookLike([[t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
          grid.insert(t1x2, 1, 0);
          expect(matrix).toLookLike([[u, t1x2, u], [u, t1x2, u], [t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
          grid.insert(t2x3, 0, 0);
          expect(matrix).toLookLike([[t2x3, t2x3, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [u, t1x2, u], [u, t1x2, u], [t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
          grid.insert(t2x2, 0, 0);
          expect(matrix).toLookLike([[t2x2, t2x2, u], [t2x2, t2x2, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [u, t1x2, u], [u, t1x2, u], [t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
          grid.insert(t2x2, 0, 3);
          expect(matrix).toLookLike([[u, u, u], [u, u, u], [u, u, u], [t2x2, t2x2, u], [t2x2, t2x2, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [u, t1x2, u], [u, t1x2, u], [t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
          grid.insert(t2x2, 0, 7);
          return expect(matrix).toLookLike([[u, u, u], [u, u, u], [u, u, u], [u, u, u], [u, u, u], [u, u, u], [u, u, u], [t2x2, t2x2, u], [t2x2, t2x2, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [t2x3, t2x3, u], [u, t1x2, u], [u, t1x2, u], [t2x1, t2x1, u], [t1x1, u, u], [t3x1, t3x1, t3x1]]);
        });
      });
    });
    return describe('#floatUp', function() {
      return it('moves a tile upwards until it encounters a barrier', function() {
        grid.insert(t1x1, 0, 1);
        expect(matrix).toLookLike([[u], [t1x1]]);
        grid.floatUp(t1x1);
        expect(matrix).toLookLike([[t1x1]]);
        grid.insert(t2x2, 0, 4);
        expect(matrix).toLookLike([[t1x1, u], [u, u], [u, u], [u, u], [t2x2, t2x2], [t2x2, t2x2]]);
        grid.floatUp(t2x2);
        expect(matrix).toLookLike([[t1x1, u], [t2x2, t2x2], [t2x2, t2x2]]);
        grid.insert(t3x2, 2, 4);
        expect(matrix).toLookLike([[t1x1, u, u, u, u], [t2x2, t2x2, u, u, u], [t2x2, t2x2, u, u, u], [u, u, u, u, u], [u, u, t3x2, t3x2, t3x2], [u, u, t3x2, t3x2, t3x2]]);
        grid.floatUp(t3x2);
        expect(matrix).toLookLike([[t1x1, u, t3x2, t3x2, t3x2], [t2x2, t2x2, t3x2, t3x2, t3x2], [t2x2, t2x2, u, u, u]]);
        grid.insert(t2x1, 1, 4);
        expect(matrix).toLookLike([[t1x1, u, t3x2, t3x2, t3x2], [t2x2, t2x2, t3x2, t3x2, t3x2], [t2x2, t2x2, u, u, u], [u, u, u, u, u], [u, t2x1, t2x1, u, u]]);
        grid.floatUp(t2x1);
        return expect(matrix).toLookLike([[t1x1, u, t3x2, t3x2, t3x2], [t2x2, t2x2, t3x2, t3x2, t3x2], [t2x2, t2x2, u, u, u], [u, t2x1, t2x1, u, u]]);
      });
    });
    /*
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
    */

  });

}).call(this);

(function() {
  describe('A Tile class', function() {
    var GRID, tile;
    GRID = 'grid';
    tile = void 0;
    beforeEach(function() {
      return tile = new Tile;
    });
    describe('#setPos', function() {
      it('sets the @grid, @col and @row attributes', function() {
        tile.setPos(GRID, 1, 2);
        expect(tile.grid).toBe(GRID);
        expect(tile.col).toBe(1);
        return expect(tile.row).toBe(2);
      });
      return it('nulls the @col and @row attributes if @grid is null', function() {
        tile.setPos(null);
        expect(tile.grid).toBe(null);
        expect(tile.col).toBe(null);
        return expect(tile.row).toBe(null);
      });
    });
    return describe('#setSize', function() {
      it('sets the @sizex and @sizey attributes', function() {
        tile.setSize(1, 2);
        expect(tile.sizex).toBe(1);
        return expect(tile.sizey).toBe(2);
      });
      return it('throws an error if a size is <= 0', function() {
        expect(function() {
          return tile.setSize(0, 0);
        }).toThrow();
        expect(function() {
          return tile.setSize(1, 0);
        }).toThrow();
        expect(function() {
          return tile.setSize(0, 1);
        }).toThrow();
        expect(function() {
          return tile.setSize(-1, 1);
        }).toThrow();
        return expect(function() {
          return tile.setSize(1, -1);
        }).toThrow();
      });
    });
  });

}).call(this);

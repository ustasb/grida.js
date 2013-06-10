(function() {
  var $DOCUMENT, $WINDOW, Grid, Tile, TileGrid,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $WINDOW = $(window);

  $DOCUMENT = $(document);

  Grid = (function() {
    function Grid() {
      this.grid = [[]];
    }

    Grid.prototype.set = function(item, col, row, sizex, sizey) {
      var grid, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      grid = this.grid;
      if (col < 0 || row < 0 || sizex < 0 || sizey < 0) {
        throw 'col, row, sizex and sizey cannot be negative.';
      }
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (!grid[tempRow]) {
          grid[tempRow] = [];
        }
        for (x = _j = 0; _j < sizex; x = _j += 1) {
          grid[tempRow][col + x] = item;
        }
      }
      return null;
    };

    Grid.prototype.get = function(col, row, sizex, sizey) {
      var grid, inArray, item, items, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      grid = this.grid;
      inArray = $.inArray;
      items = [];
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (grid[tempRow]) {
          for (x = _j = 0; _j < sizex; x = _j += 1) {
            item = grid[tempRow][col + x];
            if (item && inArray(item, items) === -1) {
              items.push(item);
            }
          }
        }
      }
      return items;
    };

    Grid.prototype.clear = function(col, row, sizex, sizey) {
      var grid, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      grid = this.grid;
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (grid[tempRow]) {
          for (x = _j = 0; _j < sizex; x = _j += 1) {
            delete grid[tempRow][col + x];
          }
        }
      }
      return null;
    };

    return Grid;

  })();

  TileGrid = (function(_super) {
    __extends(TileGrid, _super);

    TileGrid.POS_TRADE_TYPES = {
      NONE: 0,
      NEIGHBOR_HORIZONTAL: 1,
      NEIGHBOR_VERTICAL: 2,
      NEIGHBOR_HORIZONTAL_VERTICAL: 3,
      NEIGHBOR_ALL: 4,
      HORIZONTAL: 5,
      VERTICAL: 6,
      HORIZONTAL_VERTICAL: 7,
      ALL: 8
    };

    function TileGrid(tilex, tiley, marginx, marginy) {
      TileGrid.__super__.constructor.call(this);
      this.tilex = function() {
        return tilex;
      };
      this.tiley = function() {
        return tiley;
      };
      this.marginx = function() {
        return marginx;
      };
      this.marginy = function() {
        return marginy;
      };
      this.colToLeft = function(col) {
        return marginx + col * (tilex + marginx);
      };
      this.leftToCol = function(left) {
        return (left - marginx) / (tilex + marginx);
      };
      this.rowToTop = function(row) {
        return marginy + row * (tiley + marginy);
      };
      this.topToRow = function(top) {
        return (top - marginy) / (tiley + marginy);
      };
      this.sizeToWidth = function(size) {
        if (size <= 0) {
          if (size === 0) {
            return 0;
          }
          throw 'A size cannot be negative.';
        } else {
          return size * (tilex + marginx) - marginx;
        }
      };
      this.widthToSize = function(width) {
        if (width <= 0) {
          if (width === 0) {
            return 0;
          }
          throw 'A width cannot be negative.';
        } else {
          return (width + marginx) / (tilex + marginx);
        }
      };
      this.sizeToHeight = function(size) {
        if (size <= 0) {
          if (size === 0) {
            return 0;
          }
          throw 'A size cannot be negative.';
        } else {
          return size * (tiley + marginy) - marginy;
        }
      };
      this.heightToSize = function(height) {
        if (height <= 0) {
          if (height === 0) {
            return 0;
          }
          throw 'A height cannot be negative.';
        } else {
          return (height + marginy) / (tiley + marginy);
        }
      };
    }

    TileGrid.prototype.insertAt = function(tile, col, row, tradeType) {
      if (tradeType == null) {
        tradeType = TileGrid.POS_TRADE_TYPES.NEIGHBOR_VERTICAL;
      }
      this.set(tile, col, row, tile.sizex, tile.sizey);
      return null;
    };

    return TileGrid;

  })(Grid);

  Tile = (function() {
    function Tile(grid, sizex, sizey) {
      this.grid = grid;
      this.sizex = sizex != null ? sizex : 1;
      this.sizey = sizey != null ? sizey : 1;
      this.col = null;
      this.row = null;
    }

    Tile.prototype.moveTo = function(col, row) {
      this.col = col;
      return this.row = row;
    };

    return Tile;

  })();

}).call(this);

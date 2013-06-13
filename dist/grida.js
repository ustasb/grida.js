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
            if ((item != null) && inArray(item, items) === -1) {
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

    TileGrid.prototype.insertAt = function(focusTile, col, row) {
      var dy, obstructingTiles, tile, _i;
      focusTile.releasePosition();
      obstructingTiles = this.get(col, row, focusTile.sizex, focusTile.sizey);
      for (_i = obstructingTiles.length - 1; _i >= 0; _i += -1) {
        tile = obstructingTiles[_i];
        this.clear(tile.col, tile.row, tile.sizex, tile.sizey);
        dy = (row + focusTile.sizey) - tile.row;
        this.insertAt(tile, tile.col, tile.row + dy);
      }
      focusTile.setPosition(this, col, row);
      return null;
    };

    TileGrid.prototype.collapseAboveEmptySpace = function(focusTile, targetRow) {
      var aboveTiles, col, neighborRow, newRow, tile, _i;
      if (targetRow == null) {
        targetRow = 0;
      }
      if (targetRow < 0) {
        throw new RangeError('targetRow cannot be less than 0.');
      }
      if (focusTile.isInGrid() === false || targetRow >= focusTile.row) {
        return null;
      }
      aboveTiles = this.get(focusTile.col, targetRow, focusTile.sizex, focusTile.row - targetRow);
      newRow = targetRow;
      for (_i = aboveTiles.length - 1; _i >= 0; _i += -1) {
        tile = aboveTiles[_i];
        neighborRow = tile.row + tile.sizey;
        if (neighborRow > newRow) {
          newRow = neighborRow;
        }
      }
      if (newRow !== focusTile.row) {
        col = focusTile.col;
        focusTile.releasePosition();
        focusTile.setPosition(this, col, newRow);
      }
      return null;
    };

    TileGrid.prototype.swapWithTilesAt = (function() {
      var canSwap;
      canSwap = function(grid, focusTile, col, row, testInverse) {
        var c, index, r, tile, tilesToSwap, _i, _len;
        if (testInverse == null) {
          testInverse = true;
        }
        tilesToSwap = grid.get(col, row, focusTile.sizex, focusTile.sizey);
        index = $.inArray(focusTile, tilesToSwap);
        if (index !== -1) {
          if (tilesToSwap.length > 1) {
            return false;
          } else {
            tilesToSwap.splice(index, 1);
          }
        }
        for (_i = 0, _len = tilesToSwap.length; _i < _len; _i++) {
          tile = tilesToSwap[_i];
          if (tile.col < col || tile.row < row || tile.col + tile.sizex > col + focusTile.sizex || tile.row + tile.sizey > row + focusTile.sizey) {
            if (testInverse === false) {
              return false;
            } else {
              c = focusTile.col - (col - tile.col);
              r = focusTile.row - (row - tile.row);
              if (c < 0 || r < 0 || canSwap(grid, tile, c, r, false) === false) {
                return false;
              }
            }
          }
        }
        return tilesToSwap;
      };
      return function(focusTile, col, row) {
        var fc, fr, tc, tile, tilesToSwap, tr, _i, _len;
        if (focusTile.col === col && focusTile.row === row) {
          return false;
        }
        tilesToSwap = canSwap(this, focusTile, col, row);
        if (tilesToSwap === false) {
          return false;
        } else {
          fc = focusTile.col;
          fr = focusTile.row;
          focusTile.releasePosition();
          for (_i = 0, _len = tilesToSwap.length; _i < _len; _i++) {
            tile = tilesToSwap[_i];
            tc = tile.col;
            tr = tile.row;
            tile.releasePosition();
            tile.setPosition(this, fc - (col - tc), fr - (row - tr));
          }
          focusTile.setPosition(this, col, row);
          return true;
        }
      };
    })();

    return TileGrid;

  })(Grid);

  Tile = (function() {
    function Tile(sizex, sizey) {
      this.sizex = sizex != null ? sizex : 1;
      this.sizey = sizey != null ? sizey : 1;
      this.col = null;
      this.row = null;
    }

    Tile.prototype.setPosition = function(grid, col, row) {
      this.grid = grid;
      this.col = col;
      this.row = row;
      grid.set(this, col, row, this.sizex, this.sizey);
      return null;
    };

    Tile.prototype.releasePosition = function() {
      if (this.isInGrid()) {
        this.grid.clear(this.col, this.row, this.sizex, this.sizey);
        this.col = null;
        this.row = null;
      }
      return null;
    };

    Tile.prototype.isInGrid = function() {
      return (this.grid != null) && (this.col != null) && (this.row != null);
    };

    return Tile;

  })();

}).call(this);

var $DOCUMENT, $WINDOW;

$WINDOW = $(window);

$DOCUMENT = $(document);







var Grid;

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

  Grid.prototype.clear = function(col, row, sizex, sizey, specificItem) {
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
          if (specificItem === void 0 || specificItem === grid[tempRow][col + x]) {
            delete grid[tempRow][col + x];
          }
        }
      }
    }
    return null;
  };

  return Grid;

})();

var TileGrid,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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
        throw new RangeError('A size cannot be negative.');
      }
      return size * (tilex + marginx) - marginx;
    };
    this.widthToSize = function(width) {
      if (width <= 0) {
        if (width === 0) {
          return 0;
        }
        throw new RangeError('A width cannot be negative.');
      }
      return (width + marginx) / (tilex + marginx);
    };
    this.sizeToHeight = function(size) {
      if (size <= 0) {
        if (size === 0) {
          return 0;
        }
        throw new RangeError('A size cannot be negative.');
      }
      return size * (tiley + marginy) - marginy;
    };
    this.heightToSize = function(height) {
      if (height <= 0) {
        if (height === 0) {
          return 0;
        }
        throw new RangeError('A height cannot be negative.');
      }
      return (height + marginy) / (tiley + marginy);
    };
  }

  TileGrid.prototype.insertAt = function(focusTile, col, row) {
    var dy, obstructingTiles, tile, _i;
    focusTile.releasePosition();
    obstructingTiles = this.get(col, row, focusTile.sizex, focusTile.sizey);
    for (_i = obstructingTiles.length - 1; _i >= 0; _i += -1) {
      tile = obstructingTiles[_i];
      dy = (row + focusTile.sizey) - tile.row;
      this.insertAt(tile, tile.col, tile.row + dy);
    }
    focusTile.setPosition(this, col, row);
    return null;
  };

  TileGrid.prototype.collapseAboveEmptySpace = function(focusTile, targetRow) {
    var aboveTiles, neighborRow, newRow, tile, _i;
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
      focusTile.setPosition(this, focusTile.col, newRow);
    }
    return null;
  };

  TileGrid.prototype.swapWithTilesAt = (function() {
    var canSwap;
    canSwap = function(grid, focusTile, col, row, testInverse) {
      var index, newCol, newRow, obstructingTiles, tile, _i, _len;
      if (testInverse == null) {
        testInverse = true;
      }
      obstructingTiles = grid.get(col, row, focusTile.sizex, focusTile.sizey);
      index = $.inArray(focusTile, obstructingTiles);
      if (index !== -1) {
        if (obstructingTiles.length > 1) {
          return false;
        }
        obstructingTiles.splice(index, 1);
      }
      for (_i = 0, _len = obstructingTiles.length; _i < _len; _i++) {
        tile = obstructingTiles[_i];
        if (tile.col < col || tile.row < row || tile.col + tile.sizex > col + focusTile.sizex || tile.row + tile.sizey > row + focusTile.sizey) {
          if (testInverse === false) {
            return false;
          }
          newCol = focusTile.col - (col - tile.col);
          newRow = focusTile.row - (row - tile.row);
          if (newCol < 0 || newRow < 0 || canSwap(grid, tile, newCol, newRow, false) === false) {
            return false;
          }
        }
      }
      return obstructingTiles;
    };
    return function(focusTile, col, row) {
      var newCol, newRow, tile, tilesToSwap, _i, _len;
      if (focusTile.col === col && focusTile.row === row) {
        return false;
      }
      tilesToSwap = canSwap(this, focusTile, col, row);
      if (tilesToSwap === false) {
        return false;
      }
      for (_i = 0, _len = tilesToSwap.length; _i < _len; _i++) {
        tile = tilesToSwap[_i];
        newCol = focusTile.col - (col - tile.col);
        newRow = focusTile.row - (row - tile.row);
        tile.setPosition(this, newCol, newRow);
      }
      focusTile.setPosition(this, col, row);
      return true;
    };
  })();

  return TileGrid;

})(Grid);

var Tile;

Tile = (function() {
  function Tile(sizex, sizey) {
    this.sizex = sizex != null ? sizex : 1;
    this.sizey = sizey != null ? sizey : 1;
    if (sizex < 0 || sizey < 0) {
      throw new RangeError('A size cannot be negative.');
    }
    this.col = null;
    this.row = null;
  }

  Tile.prototype.setPosition = function(grid, col, row) {
    this.releasePosition();
    this.grid = grid;
    this.col = col;
    this.row = row;
    grid.set(this, col, row, this.sizex, this.sizey);
    return null;
  };

  Tile.prototype.releasePosition = function() {
    if (!this.isInGrid()) {
      return null;
    }
    this.grid.clear(this.col, this.row, this.sizex, this.sizey, this);
    this.grid = null;
    this.col = null;
    this.row = null;
    return null;
  };

  Tile.prototype.isInGrid = function() {
    return (this.grid != null) && (this.col != null) && (this.row != null);
  };

  return Tile;

})();



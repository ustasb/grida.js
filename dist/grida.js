(function() {
  var $DOCUMENT, $WINDOW, Draggable, Grid, HTMLTile, HTMLTileGrid, SnapDraggable, Tile, TileGrid,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $WINDOW = $(window);

  $DOCUMENT = $(document);

  Draggable = (function() {
    Draggable.create = function(el, grid) {
      if (grid) {
        return new SnapDraggable(el, grid);
      } else {
        return new Draggable(el);
      }
    };

    function Draggable(el) {
      this.el = $(el).get(0);
      this.setCssAbsolute();
      this.initEvents();
    }

    Draggable.prototype.setCssAbsolute = function() {
      var el, position;
      el = this.el;
      position = $(el).position();
      el.style.position = 'absolute';
      el.style.left = position.left + 'px';
      return el.style.top = position.top + 'px';
    };

    Draggable.prototype.initEvents = function() {
      var $el, mousemove,
        _this = this;
      $el = $(this.el);
      mousemove = null;
      $el.mousedown(function(event) {
        $el.trigger('xxx-draggable-mousedown', [event]);
        mousemove = _this.getMousemoveCB(event.pageX, event.pageY);
        $DOCUMENT.mousemove(mousemove);
        return false;
      });
      return $el.mouseup(function(event) {
        $el.trigger('xxx-draggable-mouseup', [event]);
        $DOCUMENT.unbind('mousemove', mousemove);
        return mousemove = null;
      });
    };

    Draggable.prototype.getMousemoveCB = function(mousex, mousey) {
      var el, position, startLeft, startTop;
      el = this.el;
      position = $(el).position();
      startLeft = mousex - position.left;
      startTop = mousey - position.top;
      return function(event) {
        el.style.left = event.pageX - startLeft + 'px';
        return el.style.top = event.pageY - startTop + 'px';
      };
    };

    return Draggable;

  })();

  SnapDraggable = (function(_super) {
    __extends(SnapDraggable, _super);

    function SnapDraggable(el, grid) {
      this.grid = grid;
      SnapDraggable.__super__.constructor.call(this, el);
    }

    SnapDraggable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, grid, oldColRow, position, round, startLeft, startTop;
      el = this.el;
      $el = $(el);
      grid = this.grid;
      round = Math.round;
      position = $el.position();
      startLeft = mousex - position.left;
      startTop = mousey - position.top;
      oldColRow = round(grid.leftToCol(position.left)) + 'x' + round(grid.topToRow(position.top));
      return function(event) {
        var col, colRow, left, row, top;
        left = event.pageX - startLeft;
        top = event.pageY - startTop;
        col = round(grid.leftToCol(left));
        row = round(grid.topToRow(top));
        colRow = col + 'x' + row;
        if (oldColRow !== colRow) {
          $el.trigger('xxx-draggable-snap', [col, row]);
          oldColRow = colRow;
        }
        el.style.left = grid.colToLeft(col) + 'px';
        return el.style.top = grid.rowToTop(row) + 'px';
      };
    };

    return SnapDraggable;

  })(Draggable);

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

  TileGrid = (function(_super) {
    var InsertType;

    __extends(TileGrid, _super);

    InsertType = {
      COLLAPSE_UP: 1,
      SHIFT_DOWN: 1,
      SHIFT_DOWN: 1
    };

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

    function TileGrid() {
      TileGrid.__super__.constructor.apply(this, arguments);
    }

    TileGrid.prototype.addTile = function(tile, col, row) {
      this.set(tile, col, row, tile.sizex, tile.sizey);
      return null;
    };

    TileGrid.prototype.removeTile = function(tile) {
      this.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile);
      return null;
    };

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

    TileGrid.prototype.attemptInsertAt = function(focusTile, col, row) {
      var obstructingTiles, tile, _i, _len;
      if (col < 0 || row < 0) {
        return false;
      }
      if (row === 0) {
        this.insertAt(focusTile, col, row);
        return true;
      }
      if (this.swapWithTilesAt(focusTile, col, row) === true) {
        this.collapseAboveEmptySpace(focusTile);
        return true;
      }
      obstructingTiles = this.get(col, row, focusTile.sizex, focusTile.sizey);
      for (_i = 0, _len = obstructingTiles.length; _i < _len; _i++) {
        tile = obstructingTiles[_i];
        if (tile.row === row) {
          this.insertAt(focusTile, col, row);
          return true;
        }
      }
      return false;
    };

    return TileGrid;

  })(Grid);

  HTMLTileGrid = (function(_super) {
    __extends(HTMLTileGrid, _super);

    function HTMLTileGrid($container, tilex, tiley, marginx, marginy) {
      this.$container = $container;
      this.tilex = tilex;
      this.tiley = tiley;
      this.marginx = marginx;
      this.marginy = marginy;
      HTMLTileGrid.__super__.constructor.apply(this, arguments);
      this.initConversionUtils(tilex, tiley, marginx, marginy);
      this.tiles = [];
      this.maxCol = this.getMaxCol();
      this.centeringOffset = this.getCenteringOffset();
      this.initEvents();
    }

    HTMLTileGrid.prototype.initEvents = function() {
      var update,
        _this = this;
      update = function() {
        var tile, _i, _len, _ref;
        _this.grid = [];
        _ref = _this.tiles.slice(0);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tile = _ref[_i];
          _this.appendAtFreeSpace(tile);
        }
        HTMLTile.updateChangedTiles();
        return null;
      };
      return $WINDOW.resize(function() {
        _this.maxCol = _this.getMaxCol();
        _this.centeringOffset = _this.getCenteringOffset(_this.maxCol);
        return update();
      });
    };

    HTMLTileGrid.prototype.getMaxCol = function() {
      var maxCol, width;
      width = this.$container.width() - (2 * this.marginx);
      if (width < this.tilex) {
        return 0;
      }
      maxCol = Math.floor(this.widthToSize(width)) - 1;
      return maxCol;
    };

    HTMLTileGrid.prototype.getCenteringOffset = function(maxCol) {
      var offset, width;
      if (maxCol == null) {
        maxCol = this.getMaxCol();
      }
      width = this.sizeToWidth(maxCol + 1) + (2 * this.marginx);
      offset = (this.$container.width() - width) / 2;
      if (offset < 0) {
        return 0;
      }
      return offset;
    };

    HTMLTileGrid.prototype.initConversionUtils = function(tilex, tiley, marginx, marginy) {
      this.colToLeft = function(col) {
        return this.centeringOffset + marginx + col * (tilex + marginx);
      };
      this.leftToCol = function(left) {
        return (left - marginx - this.centeringOffset) / (tilex + marginx);
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
      return this.heightToSize = function(height) {
        if (height <= 0) {
          if (height === 0) {
            return 0;
          }
          throw new RangeError('A height cannot be negative.');
        }
        return (height + marginy) / (tiley + marginy);
      };
    };

    HTMLTileGrid.prototype.addTile = function(focusTile, col, row) {
      HTMLTileGrid.__super__.addTile.apply(this, arguments);
      this.tiles.push(focusTile);
      return null;
    };

    HTMLTileGrid.prototype.removeTile = function(focusTile) {
      var index;
      HTMLTileGrid.__super__.removeTile.apply(this, arguments);
      index = $.inArray(focusTile, this.tiles);
      if (index !== -1) {
        this.tiles.splice(index, 1);
      }
      return null;
    };

    HTMLTileGrid.prototype.appendAtFreeSpace = function(focusTile, col, row) {
      var memberMaxCol, sizex, sizey, spaceIsFree;
      if (col == null) {
        col = 0;
      }
      if (row == null) {
        row = 0;
      }
      sizex = focusTile.sizex;
      sizey = focusTile.sizey;
      spaceIsFree = this.get(col, row, sizex, sizey).length === 0;
      memberMaxCol = col + (sizex - 1);
      if (memberMaxCol > this.maxCol) {
        if (sizex > (this.maxCol + 1) && spaceIsFree) {
          this.insertAt(focusTile, col, row);
        } else {
          this.appendAtFreeSpace(focusTile, 0, row + 1);
        }
      } else if (spaceIsFree) {
        this.insertAt(focusTile, col, row);
      } else {
        this.appendAtFreeSpace(focusTile, col + 1, row);
      }
      return null;
    };

    return HTMLTileGrid;

  })(TileGrid);

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
      this.grid.addTile(this, col, row);
      return null;
    };

    Tile.prototype.releasePosition = function() {
      if (!this.isInGrid()) {
        return null;
      }
      this.grid.removeTile(this);
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

  HTMLTile = (function(_super) {
    var changedTiles, count;

    __extends(HTMLTile, _super);

    count = 0;

    changedTiles = {};

    HTMLTile.updateChangedTiles = function() {
      var tile, _;
      for (_ in changedTiles) {
        tile = changedTiles[_];
        tile.updatePos();
        tile.updateSize();
      }
      return changedTiles = {};
    };

    function HTMLTile(el, sizex, sizey) {
      this.el = el;
      HTMLTile.__super__.constructor.call(this, sizex, sizey);
      this.id = count++;
      el.style.position = 'absolute';
      this.makeDraggable();
    }

    HTMLTile.prototype.makeDraggable = function() {
      var $el,
        _this = this;
      $el = $(this.el);
      this.draggable = new SnapDraggable(this.el);
      $el.on('xxx-draggable-mousedown', function(e) {});
      $el.on('xxx-draggable-mouseup', function(e) {});
      return $el.on('xxx-draggable-snap', function(e, col, row) {
        _this.grid.insertAt(_this, col, row);
        return HTMLTile.updateChangedTiles();
      });
    };

    HTMLTile.prototype.setPosition = function(grid, col, row) {
      HTMLTile.__super__.setPosition.apply(this, arguments);
      this.draggable.grid = grid;
      changedTiles[this.id] = this;
      return null;
    };

    HTMLTile.prototype.updateSize = function() {
      this.el.style.width = this.grid.sizeToWidth(this.sizex) + 'px';
      this.el.style.height = this.grid.sizeToHeight(this.sizey) + 'px';
      return null;
    };

    HTMLTile.prototype.updatePos = function() {
      this.el.style.left = this.grid.colToLeft(this.col) + 'px';
      this.el.style.top = this.grid.rowToTop(this.row) + 'px';
      return null;
    };

    return HTMLTile;

  })(Tile);

  $.fn.grida = function(opts) {
    var $child, child, grid, marginx, marginy, sizex, sizey, tile, tilex, tiley, _i, _len, _ref;
    marginx = opts.margins[0];
    marginy = opts.margins[1];
    tilex = opts.base_dimensions[0];
    tiley = opts.base_dimensions[1];
    grid = new HTMLTileGrid(this, tilex, tiley, marginx, marginy);
    _ref = this.children();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      $child = $(child);
      sizex = $child.data('xxx-sizex');
      sizey = $child.data('xxx-sizey');
      tile = new HTMLTile(child, sizex, sizey);
      grid.appendAtFreeSpace(tile);
    }
    return HTMLTile.updateChangedTiles();
  };

}).call(this);

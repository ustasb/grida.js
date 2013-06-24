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
      var $el, mousemove, oldzIndex,
        _this = this;
      $el = $(this.el);
      oldzIndex = null;
      mousemove = null;
      $el.mousedown(function(event) {
        oldzIndex = $el.css('z-index');
        $el.css('z-index', 99999);
        $el.trigger('xxx-draggable-mousedown', [event]);
        mousemove = _this.getMousemoveCB(event.pageX, event.pageY);
        $DOCUMENT.mousemove(mousemove);
        return false;
      });
      return $WINDOW.mouseup(function(event) {
        if (!mousemove) {
          return null;
        }
        $el.css('z-index', oldzIndex);
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
        el.style.left = left + 'px';
        return el.style.top = top + 'px';
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
    __extends(TileGrid, _super);

    function TileGrid() {
      TileGrid.__super__.constructor.apply(this, arguments);
    }

    TileGrid.prototype.setTile = function(tile, col, row) {
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
        while (--dy >= 0) {
          this.insertAt(tile, tile.col, tile.row + 1);
        }
      }
      focusTile.setPosition(this, col, row);
      return null;
    };

    TileGrid.prototype.getLowestAboveRow = function(focusTile, newCol, newRow) {
      var col, lowestRow, sizex;
      col = newCol || focusTile.col;
      lowestRow = newRow || focusTile.row;
      sizex = focusTile.sizex;
      while (lowestRow > 0 && this.get(col, lowestRow - 1, sizex, 1).length === 0) {
        lowestRow -= 1;
      }
      return lowestRow;
    };

    TileGrid.prototype.collapseAboveEmptySpace = function(focusTile) {
      var newRow;
      if (focusTile.isInGrid() === false || focusTile.row === 0) {
        return null;
      }
      newRow = this.getLowestAboveRow(focusTile);
      if (newRow !== focusTile.row) {
        focusTile.setPosition(this, focusTile.col, newRow);
      }
      return null;
    };

    TileGrid.prototype.collapseNeighborsAfter = function(focusTile, callback) {
      var belowNeighbors, neighbor, _i, _len, _results,
        _this = this;
      belowNeighbors = this.get(focusTile.col, focusTile.row + focusTile.sizey, focusTile.sizex, 1);
      if (callback != null) {
        callback();
      }
      _results = [];
      for (_i = 0, _len = belowNeighbors.length; _i < _len; _i += 1) {
        neighbor = belowNeighbors[_i];
        _results.push(this.collapseNeighborsAfter(neighbor, function() {
          return _this.collapseAboveEmptySpace(neighbor);
        }));
      }
      return _results;
    };

    TileGrid.prototype.swapIfPossible = function(focusTile, col, row) {
      var dy, newRow, obstructingTiles, swapOccured, tile, _i, _j, _len, _len1,
        _this = this;
      if (row === focusTile.row) {
        return false;
      }
      swapOccured = false;
      this.removeTile(focusTile);
      obstructingTiles = this.get(col, row, focusTile.sizex, focusTile.sizey);
      if (row > focusTile.row) {
        for (_i = 0, _len = obstructingTiles.length; _i < _len; _i += 1) {
          tile = obstructingTiles[_i];
          newRow = this.getLowestAboveRow(tile);
          if (newRow + tile.sizey === row) {
            swapOccured = true;
            this.collapseNeighborsAfter(tile, function() {
              return _this.insertAt(tile, tile.col, newRow);
            });
          }
        }
      } else {
        dy = focusTile.row - row;
        for (_j = 0, _len1 = obstructingTiles.length; _j < _len1; _j += 1) {
          tile = obstructingTiles[_j];
          if (tile.sizey === dy) {
            swapOccured = true;
            break;
          }
        }
      }
      if (swapOccured) {
        this.collapseNeighborsAfter(focusTile, function() {
          return _this.insertAt(focusTile, col, row);
        });
      } else {
        this.setTile(focusTile, focusTile.col, focusTile.row);
      }
      return swapOccured;
    };

    TileGrid.prototype.attemptInsertAt = function(focusTile, col, row) {
      var aboveTiles, newRow, tile, _i, _len,
        _this = this;
      if (row === 0) {
        this.collapseNeighborsAfter(focusTile, function() {
          return _this.insertAt(focusTile, col, row);
        });
        return true;
      }
      if (this.swapIfPossible(focusTile, col, row)) {
        return true;
      }
      this.removeTile(focusTile);
      aboveTiles = this.get(col, row - 1, focusTile.sizex, 1);
      if (aboveTiles.length === 0) {
        newRow = this.getLowestAboveRow(focusTile, col, row);
        this.collapseNeighborsAfter(focusTile, function() {
          return focusTile.setPosition(_this, col, newRow);
        });
        return true;
      }
      for (_i = 0, _len = aboveTiles.length; _i < _len; _i += 1) {
        tile = aboveTiles[_i];
        if (tile.row + tile.sizey === row) {
          this.collapseNeighborsAfter(focusTile, function() {
            return _this.insertAt(focusTile, col, row);
          });
          return true;
        }
      }
      this.setTile(focusTile, focusTile.col, focusTile.row);
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
      var _this = this;
      return $WINDOW.resize(function() {
        var tile, _i, _len, _ref;
        _this.maxCol = _this.getMaxCol();
        _this.centeringOffset = _this.getCenteringOffset(_this.maxCol);
        _this.grid = [];
        _ref = _this.tiles.slice(0);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tile = _ref[_i];
          _this.appendAtFreeSpace(tile);
        }
        return HTMLTile.updateChangedTiles();
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

    HTMLTileGrid.prototype.setTile = function(focusTile, col, row) {
      var index;
      HTMLTileGrid.__super__.setTile.apply(this, arguments);
      index = $.inArray(focusTile, this.tiles);
      if (index === -1) {
        this.tiles.push(focusTile);
      }
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

    HTMLTileGrid.prototype.sortTilesByPos = function() {
      this.tiles.sort(function(a, b) {
        if (a.row < b.row) {
          return -1;
        }
        if (a.row === b.row && a.col < b.col) {
          return -1;
        }
        return 1;
      });
      return null;
    };

    HTMLTileGrid.prototype.appendAtFreeSpace = function(focusTile, col, row) {
      var isSpaceEmpty, memberMaxCol, sizex, sizey;
      if (col == null) {
        col = 0;
      }
      if (row == null) {
        row = 0;
      }
      sizex = focusTile.sizex;
      sizey = focusTile.sizey;
      isSpaceEmpty = this.get(col, row, sizex, sizey).length === 0;
      memberMaxCol = col + (sizex - 1);
      if (memberMaxCol > this.maxCol) {
        if (sizex > (this.maxCol + 1) && isSpaceEmpty) {
          this.insertAt(focusTile, col, row);
        } else {
          this.appendAtFreeSpace(focusTile, 0, row + 1);
        }
      } else if (isSpaceEmpty) {
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
      this.grid.setTile(this, col, row);
      return null;
    };

    Tile.prototype.releasePosition = function() {
      if (this.isInGrid() === false) {
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
    var _changedTiles, _count;

    __extends(HTMLTile, _super);

    _count = 0;

    _changedTiles = {};

    HTMLTile.updateChangedTiles = function() {
      var tile, _;
      for (_ in _changedTiles) {
        tile = _changedTiles[_];
        tile.updatePos();
        tile.updateSize();
      }
      return _changedTiles = {};
    };

    function HTMLTile(el, grid, sizex, sizey) {
      this.el = el;
      this.grid = grid;
      HTMLTile.__super__.constructor.call(this, sizex, sizey);
      this.id = _count++;
      el.style.position = 'absolute';
      this.makeDraggable();
    }

    HTMLTile.prototype.makeDraggable = function() {
      var $el, $ghost,
        _this = this;
      $el = $(this.el);
      $ghost = $('<div class="xxx-draggable-ghost"></div>');
      $ghost.css({
        position: 'absolute',
        backgroundColor: 'blue',
        zIndex: -1
      });
      this.draggable = new SnapDraggable(this.el, this.grid);
      $el.on('xxx-draggable-mousedown', function(e) {
        var position;
        position = $el.position();
        return $ghost.css({
          left: position.left,
          top: position.top,
          width: $el.width(),
          height: $el.height()
        }).appendTo($el.parent());
      });
      $el.on('xxx-draggable-mouseup', function(e) {
        var position;
        position = $ghost.position();
        $el.css({
          left: position.left,
          top: position.top
        });
        return $ghost.remove();
      });
      $el.on('xxx-draggable-snap', function(e, col, row) {
        var maxCol;
        if (col < 0) {
          col = 0;
        }
        if (row < 0) {
          row = 0;
        }
        maxCol = _this.grid.maxCol;
        if ((col + _this.sizex - 1) > maxCol) {
          col = maxCol - (_this.sizex - 1);
        }
        if (_this.grid.attemptInsertAt(_this, col, row) === false) {
          return null;
        }
        _this.grid.sortTilesByPos();
        $ghost.css({
          left: _this.grid.colToLeft(_this.col),
          top: _this.grid.rowToTop(_this.row)
        });
        return HTMLTile.updateChangedTiles();
      });
      return null;
    };

    HTMLTile.prototype.setPosition = function(grid, col, row) {
      HTMLTile.__super__.setPosition.apply(this, arguments);
      _changedTiles[this.id] = this;
      this.draggable.grid = grid;
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
      tile = new HTMLTile(child, grid, sizex, sizey);
      grid.appendAtFreeSpace(tile);
    }
    return HTMLTile.updateChangedTiles();
  };

}).call(this);

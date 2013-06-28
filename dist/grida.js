(function() {
  var $DOCUMENT, $WINDOW, DOMTile, DOMTileGrid, Draggable, Grid, Resizable, SnapDraggable, SnapResizable, Tile, TileGrid,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $WINDOW = $(window);

  $DOCUMENT = $(document);

  Draggable = (function() {
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

  Resizable = (function() {
    function Resizable(el) {
      this.el = $(el).get(0);
      this.addHandle();
      this.initEvents();
    }

    Resizable.prototype.addHandle = function() {
      var $handle;
      $handle = $('<div class="xxx-handle-se"></div>');
      $handle.css({
        position: 'absolute',
        bottom: 0,
        right: 0,
        width: 25,
        height: 25,
        backgroundColor: 'blue'
      });
      return $(this.el).append($handle);
    };

    Resizable.prototype.initEvents = function() {
      var $el, $handle, mousemove, oldzIndex,
        _this = this;
      $el = $(this.el);
      $handle = $el.children('.xxx-handle-se');
      oldzIndex = null;
      mousemove = null;
      $handle.mousedown(function(event) {
        event.stopPropagation();
        oldzIndex = $el.css('z-index');
        $el.css('z-index', 99999);
        $el.trigger('xxx-resizable-mousedown', [event]);
        mousemove = _this.getMousemoveCB(event.pageX, event.pageY);
        $DOCUMENT.mousemove(mousemove);
        return false;
      });
      return $WINDOW.mouseup(function(event) {
        if (!mousemove) {
          return null;
        }
        $el.css('z-index', oldzIndex);
        $el.trigger('xxx-resizable-mouseup', [event]);
        $DOCUMENT.unbind('mousemove', mousemove);
        return mousemove = null;
      });
    };

    Resizable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, startLeft, startTop;
      el = this.el;
      $el = $(el);
      startLeft = mousex - $el.width();
      startTop = mousey - $el.height();
      return function(event) {
        el.style.width = event.pageX - startLeft + 'px';
        return el.style.height = event.pageY - startTop + 'px';
      };
    };

    return Resizable;

  })();

  SnapResizable = (function(_super) {
    __extends(SnapResizable, _super);

    function SnapResizable(el, grid) {
      this.grid = grid;
      SnapResizable.__super__.constructor.call(this, el);
    }

    SnapResizable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, grid, oldSize, position, round, startLeft, startTop;
      el = this.el;
      $el = $(el);
      grid = this.grid;
      round = Math.round;
      position = $el.position();
      startLeft = mousex - $el.width();
      startTop = mousey - $el.height();
      oldSize = round(grid.widthToSize($el.width())) + 'x' + round(grid.heightToSize($el.height()));
      return function(event) {
        var height, newSize, sizex, sizey, width;
        width = event.pageX - startLeft;
        height = event.pageY - startTop;
        sizex = round(grid.widthToSize(width));
        sizey = round(grid.heightToSize(height));
        if (sizex === 0) {
          sizex = 1;
        }
        if (sizey === 0) {
          sizey = 1;
        }
        newSize = sizex + 'x' + sizey;
        if (newSize !== oldSize) {
          $el.trigger('xxx-resizable-snap', [sizex, sizey]);
          oldSize = newSize;
        }
        el.style.width = width + 'px';
        return el.style.height = height + 'px';
      };
    };

    return SnapResizable;

  })(Resizable);

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

  TileGrid = (function() {
    function TileGrid() {
      this.grid = new Grid;
      this.tiles = [];
    }

    TileGrid.prototype.validateTile = function(tile) {
      if (tile.grid !== this) {
        throw new Error("The tile does not belong to this grid!");
      }
      return null;
    };

    TileGrid.prototype.setTile = function(tile, col, row) {
      tile.setPosition(this, col, row);
      this.tiles.push(tile);
      this.grid.set(tile, col, row, tile.sizex, tile.sizey);
      return null;
    };

    TileGrid.prototype.removeTile = function(tile) {
      var index;
      index = $.inArray(tile, this.tiles);
      if (index !== -1) {
        this.grid.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile);
        this.tiles.splice(index, 1);
      }
      return null;
    };

    TileGrid.prototype.sortTilesByPos = function() {
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

    TileGrid.prototype.insertAt = function(focusTile, col, row) {
      var dy, obstructingTiles, tile, _i;
      obstructingTiles = this.grid.get(col, row, focusTile.sizex, focusTile.sizey);
      for (_i = obstructingTiles.length - 1; _i >= 0; _i += -1) {
        tile = obstructingTiles[_i];
        if (tile === focusTile) {
          continue;
        }
        dy = (row + focusTile.sizey) - tile.row;
        while (--dy >= 0) {
          this.insertAt(tile, tile.col, tile.row + 1);
        }
      }
      this.setTile(focusTile, col, row);
      return null;
    };

    TileGrid.prototype.getLowestAboveRow = function(tile, col, row) {
      var lowestRow, sizex;
      if (col == null) {
        col = tile.col;
      }
      if (row == null) {
        row = tile.row;
      }
      this.validateTile(tile);
      lowestRow = row;
      sizex = tile.sizex;
      while (lowestRow > 0 && this.grid.get(col, lowestRow - 1, sizex, 1).length === 0) {
        lowestRow -= 1;
      }
      return lowestRow;
    };

    TileGrid.prototype.collapseAboveEmptySpace = function(tile) {
      var newRow;
      this.validateTile(tile);
      newRow = this.getLowestAboveRow(tile);
      if (newRow !== tile.row) {
        this.setTile(tile, tile.col, newRow);
      }
      return null;
    };

    TileGrid.prototype.collapseNeighborsAfter = function(tile, callback) {
      var belowNeighbors, neighbor, _i, _len,
        _this = this;
      this.validateTile(tile);
      belowNeighbors = this.grid.get(tile.col, tile.row + tile.sizey, tile.sizex, 1);
      if (callback != null) {
        callback();
      }
      for (_i = 0, _len = belowNeighbors.length; _i < _len; _i += 1) {
        neighbor = belowNeighbors[_i];
        this.collapseNeighborsAfter(neighbor, function() {
          return _this.collapseAboveEmptySpace(neighbor);
        });
      }
      return null;
    };

    TileGrid.prototype.attemptInsertAt = function(focusTile, col, row) {
      var aboveTiles, lowestRow, newRow, oTile, obstructingTiles, swapOccured, tile, _i, _j, _k, _len, _len1, _len2,
        _this = this;
      if (row === 0) {
        this.collapseNeighborsAfter(focusTile, function() {
          return _this.insertAt(focusTile, col, row);
        });
        return true;
      }
      this.grid.clear(focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey);
      obstructingTiles = this.grid.get(col, row, focusTile.sizex, focusTile.sizey);
      if (row > focusTile.row) {
        for (_i = 0, _len = obstructingTiles.length; _i < _len; _i += 1) {
          oTile = obstructingTiles[_i];
          if (focusTile.row + oTile.sizey === row && this.getLowestAboveRow(oTile) === focusTile.row) {
            this.collapseNeighborsAfter(oTile, function() {
              return _this.setTile(oTile, oTile.col, focusTile.row);
            });
            swapOccured = true;
          }
        }
        if (swapOccured) {
          this.collapseNeighborsAfter(focusTile, function() {
            return _this.insertAt(focusTile, col, row);
          });
          return true;
        }
      }
      aboveTiles = this.grid.get(col, row - 1, focusTile.sizex, 1);
      if (aboveTiles.length === 0 && obstructingTiles.length === 0) {
        newRow = this.getLowestAboveRow(focusTile, col, row);
        this.collapseNeighborsAfter(focusTile, function() {
          return _this.setTile(focusTile, col, newRow);
        });
        return true;
      }
      for (_j = 0, _len1 = aboveTiles.length; _j < _len1; _j += 1) {
        tile = aboveTiles[_j];
        if (tile.row + tile.sizey === row) {
          this.collapseNeighborsAfter(focusTile, function() {
            return _this.insertAt(focusTile, col, row);
          });
          return true;
        }
      }
      for (_k = 0, _len2 = obstructingTiles.length; _k < _len2; _k += 1) {
        tile = obstructingTiles[_k];
        lowestRow = this.getLowestAboveRow(tile);
        if (lowestRow + tile.sizey === row) {
          this.collapseNeighborsAfter(tile, function() {
            _this.setTile(tile, tile.col, lowestRow);
            return _this.insertAt(focusTile, col, row);
          });
          return true;
        }
      }
      this.grid.set(focusTile, focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey);
      return false;
    };

    return TileGrid;

  })();

  DOMTileGrid = (function(_super) {
    __extends(DOMTileGrid, _super);

    function DOMTileGrid($container, tilex, tiley, marginx, marginy) {
      this.$container = $container;
      this.tilex = tilex;
      this.tiley = tiley;
      this.marginx = marginx;
      this.marginy = marginy;
      DOMTileGrid.__super__.constructor.apply(this, arguments);
      this.maxCol = this.getMaxCol();
      this.centeringOffset = this.getCenteringOffset();
      this.initEvents();
    }

    DOMTileGrid.prototype.initEvents = function() {
      var _this = this;
      return $WINDOW.resize(function() {
        var tile, _i, _len, _ref;
        _this.maxCol = _this.getMaxCol();
        _this.centeringOffset = _this.getCenteringOffset(_this.maxCol);
        _this.grid.grid = [];
        _ref = _this.tiles.slice(0);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tile = _ref[_i];
          _this.appendAtFreeSpace(tile);
        }
        return DOMTile.updateChangedTiles();
      });
    };

    DOMTileGrid.prototype.colToLeft = function(col) {
      return this.centeringOffset + this.marginx + col * (this.tilex + this.marginx);
    };

    DOMTileGrid.prototype.leftToCol = function(left) {
      return (left - this.marginx - this.centeringOffset) / (this.tilex + this.marginx);
    };

    DOMTileGrid.prototype.rowToTop = function(row) {
      return this.marginy + row * (this.tiley + this.marginy);
    };

    DOMTileGrid.prototype.topToRow = function(top) {
      return (top - this.marginy) / (this.tiley + this.marginy);
    };

    DOMTileGrid.prototype.sizeToWidth = function(size) {
      if (size <= 0) {
        return 0;
      }
      return size * (this.tilex + this.marginx) - this.marginx;
    };

    DOMTileGrid.prototype.widthToSize = function(width) {
      if (width <= 0) {
        return 0;
      }
      return (width + this.marginx) / (this.tilex + this.marginx);
    };

    DOMTileGrid.prototype.sizeToHeight = function(size) {
      if (size <= 0) {
        return 0;
      }
      return size * (this.tiley + this.marginy) - this.marginy;
    };

    DOMTileGrid.prototype.heightToSize = function(height) {
      if (height <= 0) {
        return 0;
      }
      return (height + this.marginy) / (this.tiley + this.marginy);
    };

    DOMTileGrid.prototype.getMaxCol = function() {
      var maxCol, width;
      width = this.$container.width() - (2 * this.marginx);
      if (width < this.tilex) {
        return 0;
      }
      maxCol = Math.floor(this.widthToSize(width)) - 1;
      return maxCol;
    };

    DOMTileGrid.prototype.getCenteringOffset = function(maxCol) {
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

    DOMTileGrid.prototype.appendAtFreeSpace = function(focusTile, col, row) {
      var isSpaceEmpty, memberMaxCol, sizex, sizey;
      if (col == null) {
        col = 0;
      }
      if (row == null) {
        row = 0;
      }
      sizex = focusTile.sizex;
      sizey = focusTile.sizey;
      isSpaceEmpty = this.grid.get(col, row, sizex, sizey).length === 0;
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

    return DOMTileGrid;

  })(TileGrid);

  Tile = (function() {
    var _count;

    _count = 0;

    function Tile(sizex, sizey) {
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      this.id = _count++;
      this.setSize(sizex, sizey);
      this.grid = null;
      this.col = null;
      this.row = null;
    }

    Tile.prototype.setSize = function(sizex, sizey) {
      if (this.grid != null) {
        this.grid.removeTile(this);
      }
      if (sizex < 0 || sizey < 0) {
        throw new RangeError('A size cannot be negative.');
      }
      this.sizex = sizex;
      return this.sizey = sizey;
    };

    Tile.prototype.setPosition = function(grid, col, row) {
      this.releasePosition();
      this.grid = grid;
      this.col = col;
      this.row = row;
      return null;
    };

    Tile.prototype.releasePosition = function() {
      if (this.grid != null) {
        this.grid.removeTile(this);
      }
      this.grid = null;
      this.col = null;
      this.row = null;
      return null;
    };

    return Tile;

  })();

  DOMTile = (function(_super) {
    var _changedPositions, _changedSizes;

    __extends(DOMTile, _super);

    _changedSizes = {};

    _changedPositions = {};

    DOMTile.updateChangedTiles = function() {
      var tile, _;
      for (_ in _changedSizes) {
        tile = _changedSizes[_];
        tile.updateSize();
      }
      _changedSizes = {};
      for (_ in _changedPositions) {
        tile = _changedPositions[_];
        tile.updatePos();
      }
      return _changedPositions = {};
    };

    function DOMTile(el, grid, sizex, sizey) {
      this.el = el;
      this.grid = grid;
      DOMTile.__super__.constructor.call(this, sizex, sizey);
      el.style.position = 'absolute';
      this.draggable = this.makeDraggable();
      this.resizable = this.makeResizable();
    }

    DOMTile.prototype.makeResizable = function() {
      var $el, $ghost,
        _this = this;
      $el = $(this.el);
      $ghost = $('<div class="xxx-draggable-ghost"></div>');
      $ghost.css({
        position: 'absolute',
        backgroundColor: 'blue',
        zIndex: -1
      });
      $el.on('xxx-resizable-mousedown', function(e) {
        var position;
        position = $el.position();
        return $ghost.css({
          left: position.left,
          top: position.top
        }).appendTo($el.parent());
      });
      $el.on('xxx-resizable-mouseup', function(e) {
        $el.css({
          width: $ghost.width(),
          height: $ghost.height()
        });
        return $ghost.remove();
      });
      $el.on('xxx-resizable-snap', function(e, sizex, sizey) {
        var maxCol;
        maxCol = _this.grid.maxCol;
        if (_this.col + sizex > maxCol) {
          sizex = (maxCol - _this.col) + 1;
        }
        _this.grid.collapseNeighborsAfter(_this, function() {
          _this.setSize(sizex, sizey);
          return _this.grid.insertAt(_this, _this.col, _this.row);
        });
        $ghost.css({
          width: _this.grid.sizeToWidth(sizex),
          height: _this.grid.sizeToHeight(sizey)
        });
        return DOMTile.updateChangedTiles();
      });
      return new SnapResizable(this.el, this.grid);
    };

    DOMTile.prototype.makeDraggable = function() {
      var $el, $ghost,
        _this = this;
      $el = $(this.el);
      $ghost = $('<div class="xxx-draggable-ghost"></div>');
      $ghost.css({
        position: 'absolute',
        backgroundColor: 'blue',
        zIndex: -1
      });
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
        return DOMTile.updateChangedTiles();
      });
      return new SnapDraggable(this.el, this.grid);
    };

    DOMTile.prototype.setSize = function(sizex, sizey) {
      DOMTile.__super__.setSize.apply(this, arguments);
      _changedSizes[this.id] = this;
      return null;
    };

    DOMTile.prototype.setPosition = function(grid, col, row) {
      DOMTile.__super__.setPosition.apply(this, arguments);
      _changedPositions[this.id] = this;
      this.draggable.grid = grid;
      this.resizable.grid = grid;
      return null;
    };

    DOMTile.prototype.updateSize = function() {
      this.el.style.width = this.grid.sizeToWidth(this.sizex) + 'px';
      this.el.style.height = this.grid.sizeToHeight(this.sizey) + 'px';
      return null;
    };

    DOMTile.prototype.updatePos = function() {
      this.el.style.left = this.grid.colToLeft(this.col) + 'px';
      this.el.style.top = this.grid.rowToTop(this.row) + 'px';
      return null;
    };

    return DOMTile;

  })(Tile);

  $.fn.grida = function(opts) {
    var $child, child, grid, marginx, marginy, sizex, sizey, tile, tilex, tiley, _i, _len, _ref;
    marginx = opts.margins[0];
    marginy = opts.margins[1];
    tilex = opts.base_dimensions[0];
    tiley = opts.base_dimensions[1];
    grid = new DOMTileGrid(this, tilex, tiley, marginx, marginy);
    _ref = this.children();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      $child = $(child);
      sizex = $child.data('xxx-sizex');
      sizey = $child.data('xxx-sizey');
      tile = new DOMTile(child, grid, sizex, sizey);
      grid.appendAtFreeSpace(tile);
    }
    return DOMTile.updateChangedTiles();
  };

}).call(this);

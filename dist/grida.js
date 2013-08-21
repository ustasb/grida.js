(function() {
  var $DOCUMENT, $WINDOW, DOMTile, DOMTileGrid, Draggable, Matrix2D, Resizable, SnapDraggable, SnapResizable, Tile, TileGrid,
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

  Matrix2D = (function() {
    function Matrix2D() {
      this._array2D = [[]];
    }

    Matrix2D.prototype.set = function(item, col, row, sizex, sizey) {
      var matrix, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      matrix = this._array2D;
      if (col < 0 || row < 0 || sizex < 0 || sizey < 0) {
        throw new RangeError('col, row, sizex and sizey cannot be negative.');
      }
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (matrix[tempRow] === void 0) {
          matrix[tempRow] = [];
        }
        for (x = _j = 0; _j < sizex; x = _j += 1) {
          matrix[tempRow][col + x] = item;
        }
      }
      return null;
    };

    Matrix2D.prototype.get = function(col, row, sizex, sizey) {
      var inArray, item, items, matrix, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      matrix = this._array2D;
      inArray = $.inArray;
      items = [];
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (matrix[tempRow]) {
          for (x = _j = 0; _j < sizex; x = _j += 1) {
            item = matrix[tempRow][col + x];
            if ((item != null) && inArray(item, items) === -1) {
              items.push(item);
            }
          }
        }
      }
      return items;
    };

    Matrix2D.prototype.clear = function(col, row, sizex, sizey, targetItem) {
      var matrix, tempRow, x, y, _i, _j;
      if (sizex == null) {
        sizex = 1;
      }
      if (sizey == null) {
        sizey = 1;
      }
      if (targetItem == null) {
        targetItem = void 0;
      }
      matrix = this._array2D;
      for (y = _i = 0; _i < sizey; y = _i += 1) {
        tempRow = row + y;
        if (matrix[tempRow]) {
          for (x = _j = 0; _j < sizex; x = _j += 1) {
            if (targetItem === void 0 || targetItem === matrix[tempRow][col + x]) {
              delete matrix[tempRow][col + x];
            }
          }
        }
      }
      return null;
    };

    return Matrix2D;

  })();

  TileGrid = (function() {
    function TileGrid() {
      this._matrix = new Matrix2D;
      this._tiles = {};
    }

    TileGrid.prototype._set = function(tile, newCol, newRow) {
      this._matrix.set(tile, newCol, newRow, tile.sizex, tile.sizey);
      this._tiles[tile.id] = tile;
      return tile.setPos(this, newCol, newRow);
    };

    TileGrid.prototype.remove = function(tile) {
      this._matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile);
      delete this._tiles[tile.id];
      return tile.setPos(null);
    };

    TileGrid.prototype.insert = function(tile, newCol, newRow) {
      var dy, oTile, obstructingTiles, _i, _len;
      this._matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile);
      obstructingTiles = this._matrix.get(newCol, newRow, tile.sizex, tile.sizey);
      for (_i = 0, _len = obstructingTiles.length; _i < _len; _i += 1) {
        oTile = obstructingTiles[_i];
        dy = (newRow + tile.sizey) - oTile.row;
        while (--dy >= 0) {
          this.insert(oTile, oTile.col, oTile.row + 1);
        }
      }
      this._set(tile, newCol, newRow);
      return null;
    };

    TileGrid.prototype.floatUp = function(tile) {
      var newRow;
      newRow = tile.row;
      while (newRow > 0 && this._matrix.get(tile.col, newRow - 1, tile.sizex, 1).length === 0) {
        newRow -= 1;
      }
      if (newRow === tile.row) {
        return false;
      } else {
        this._matrix.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile);
        this._set(tile, tile.col, newRow);
        return true;
      }
    };

    TileGrid.prototype.aboveNeighbors = function(tile) {
      return this._matrix.get(tile.col, tile.row - 1, tile.sizex, 1);
    };

    TileGrid.prototype.belowNeighbors = function(tile) {
      return this._matrix.get(tile.col, tile.row + 1, tile.sizex, 1);
    };

    return TileGrid;

  })();

  /*
    setTile: (tile, col, row) ->
      tile.setPosition(@, col, row)
  
      @tiles.push(tile)
  
      @grid.set(tile, col, row, tile.sizex, tile.sizey)
  
      null
  
    removeTile: (tile) ->
      index = $.inArray(tile, @tiles)
  
      if index isnt -1
        @grid.clear(tile.col, tile.row, tile.sizex, tile.sizey, tile)
        @tiles.splice(index, 1)
  
      null
  
    sortTilesByPos: ->
      @tiles.sort (a, b) ->
        return -1 if a.row < b.row
        return -1 if a.row is b.row and a.col < b.col
        return 1
  
      null
  
    # Inserts the tile at a position and shifts down any obstructing tiles.
    # @param focusTile [Tile]
    # @param col, row [whole number]
    # @return [null]
    insertAt: (focusTile, col, row) ->
      # Tiles are in row-order (smaller rows first).
      obstructingTiles = @grid.get(col, row, focusTile.sizex, focusTile.sizey)
  
      for tile in obstructingTiles by -1
        continue if tile is focusTile
        dy = (row + focusTile.sizey) - tile.row
        @insertAt(tile, tile.col, tile.row + 1) while --dy >= 0
  
      @setTile(focusTile, col, row)
  
      null
  
    # Finds the lowest above row that the tile could shift up to.
    # @param tile [Tile]
    # @param col, row [whole number]
    # @return [integer]
    getLowestAboveRow: (tile, col = tile.col, row = tile.row) ->
      @validateTile(tile)
  
      lowestRow = row
      sizex = tile.sizex
  
      while lowestRow > 0 and @grid.get(col, lowestRow - 1, sizex, 1).length is 0
        lowestRow -= 1
  
      lowestRow
  
    # Moves the tile upwards until it encounters a barrier.
    # @param tile [Tile]
    # @return [null]
    collapseAboveEmptySpace: (tile) ->
      @validateTile(tile)
  
      newRow = @getLowestAboveRow(tile)
  
      if newRow isnt tile.row
        @setTile(tile, tile.col, newRow)
  
      null
  
    # Calls the callback and recursively shifts all old below neighbors up.
    # @param tile [Tile]
    # @param callback [function]
    # @return [null]
    collapseNeighborsAfter: (tile, callback) ->
      @validateTile(tile)
  
      belowNeighbors = @grid.get(tile.col, tile.row + tile.sizey, tile.sizex, 1)
  
      callback() if callback?
  
      for neighbor in belowNeighbors by 1
        @collapseNeighborsAfter neighbor, =>
          @collapseAboveEmptySpace(neighbor)
  
      null
  
    # Tries to insert a tile at a location while maintaining the invariant:
    #
    #   Each tile must have an above neighbor tile except for tiles in row 0.
    #
    # @param focusTile [Tile]
    # @param col, row [whole number]
    # @return [boolean] success status
    attemptInsertAt: (focusTile, col, row) ->
      if row is 0
        @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
        return true
  
      @grid.clear(focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey)
      obstructingTiles = @grid.get(col, row, focusTile.sizex, focusTile.sizey)
  
      if row > focusTile.row
        for oTile in obstructingTiles by 1
          if focusTile.row + oTile.sizey is row and @getLowestAboveRow(oTile) is focusTile.row
            @collapseNeighborsAfter oTile, => @setTile(oTile, oTile.col, focusTile.row)
            swapOccured = true
  
        if swapOccured
          @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
          return true
  
      aboveTiles = @grid.get(col, row - 1, focusTile.sizex, 1)
  
      if aboveTiles.length is 0 and obstructingTiles.length is 0
        newRow = @getLowestAboveRow(focusTile, col, row)
        @collapseNeighborsAfter focusTile, => @setTile(focusTile, col, newRow)
        return true
  
      for tile in aboveTiles by 1
        if tile.row + tile.sizey is row
          @collapseNeighborsAfter focusTile, => @insertAt(focusTile, col, row)
          return true
  
      for tile in obstructingTiles by 1
        lowestRow = @getLowestAboveRow(tile)
        if lowestRow + tile.sizey is row
          @collapseNeighborsAfter tile, =>
            @setTile(tile, tile.col, lowestRow)
            @insertAt(focusTile, col, row)
          return true
  
      @grid.set(focusTile, focusTile.col, focusTile.row, focusTile.sizex, focusTile.sizey)
  
      false
  */


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
      var initTile, initWidth,
        _this = this;
      initWidth = $WINDOW.width();
      initTile = this.tilex;
      return $WINDOW.resize(function() {
        var tile, _i, _len, _ref, _results;
        _this.maxCol = _this.getMaxCol();
        _this.centeringOffset = _this.getCenteringOffset(_this.maxCol);
        _this.tilex = initTile * ($WINDOW.width() / initWidth);
        _ref = _this.tiles;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tile = _ref[_i];
          tile.updatePos();
          _results.push(tile.updateSize());
        }
        return _results;
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
      this.id = ++_count;
      this.setPos(null);
      this.setSize(sizex, sizey);
    }

    Tile.prototype.setPos = function(grid, col, row) {
      this.grid = grid != null ? grid : null;
      if (this.grid === null) {
        this.col = this.row = null;
      } else {
        this.col = col;
        this.row = row;
      }
      return null;
    };

    Tile.prototype.setSize = function(sizex, sizey) {
      if (sizex <= 0 || sizey <= 0) {
        throw new RangeError('A size must be > 0');
      }
      this.sizex = sizex;
      this.sizey = sizey;
      return null;
    };

    return Tile;

  })();

  DOMTile = (function(_super) {
    var _ANIMATE_SPEED, _changedPositions, _changedSizes, _draggingTile;

    __extends(DOMTile, _super);

    _ANIMATE_SPEED = 160;

    _changedSizes = {};

    _changedPositions = {};

    _draggingTile = null;

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
        return $el.animate({
          width: $ghost.width(),
          height: $ghost.height()
        }, _ANIMATE_SPEED, 'swing', function() {
          return $ghost.remove();
        });
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
        $ghost.css({
          left: position.left,
          top: position.top,
          width: $el.width(),
          height: $el.height()
        }).appendTo($el.parent());
        return _draggingTile = _this;
      });
      $el.on('xxx-draggable-mouseup', function(e) {
        var position;
        position = $ghost.position();
        $el.animate({
          left: position.left,
          top: position.top
        }, _ANIMATE_SPEED, 'swing', function() {
          return $ghost.remove();
        });
        return _draggingTile = null;
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
      if (_draggingTile !== this) {
        _changedSizes[this.id] = this;
      }
      return null;
    };

    DOMTile.prototype.setPosition = function(grid, col, row) {
      DOMTile.__super__.setPosition.apply(this, arguments);
      if (_draggingTile !== this) {
        _changedPositions[this.id] = this;
      }
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
      $(this.el).stop(true).animate({
        left: this.grid.colToLeft(this.col),
        top: this.grid.rowToTop(this.row)
      }, _ANIMATE_SPEED);
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

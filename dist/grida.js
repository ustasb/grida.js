(function() {
  var $DOCUMENT, $WINDOW, Draggable, Grid, GridMember, MousePos, Resizable, SnapDraggable, SnapResizable,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $WINDOW = $(window);

  $DOCUMENT = $(document);

  MousePos = (function() {
    function MousePos() {
      this.onMouseMove = function() {};
    }

    MousePos.prototype.record = function(callback) {
      this.onMouseMove = function(e) {
        return callback(e);
      };
      return $DOCUMENT.mousemove(this.onMouseMove);
    };

    MousePos.prototype.stopRecording = function() {
      return $DOCUMENT.unbind('mousemove', this.onMouseMove);
    };

    return MousePos;

  })();

  Draggable = (function() {
    Draggable.create = function(el, opts) {
      var grid, margin;

      if (opts == null) {
        opts = {};
      }
      grid = opts.grid;
      margin = opts.margin;
      if (grid) {
        return new SnapDraggable(el, grid.x, grid.y, margin.x, margin.y);
      } else {
        return new Draggable(el);
      }
    };

    function Draggable(el) {
      this.el = $(el).get(0);
      this.mousePos = new MousePos;
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
      var _this = this;

      $DOCUMENT.mouseup(function() {
        return _this.mousePos.stopRecording();
      });
      return $(this.el).mousedown(function(event) {
        _this.mousePos.record(_this.getMousemoveCB(event.pageX, event.pageY));
        return false;
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

    function SnapDraggable(el, gridx, gridy, marginx, marginy) {
      this.gridx = gridx;
      this.gridy = gridy;
      this.marginx = marginx;
      this.marginy = marginy;
      SnapDraggable.__super__.constructor.call(this, el);
    }

    SnapDraggable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, gridx, gridxHalf, gridy, gridyHalf, marginx, marginy, offsetLeft, offsetTop, oldPosCombined, position, startLeft, startTop;

      el = this.el;
      $el = $(el);
      marginx = this.marginx;
      marginy = this.marginy;
      gridx = this.gridx + marginx;
      gridy = this.gridy + marginy;
      gridxHalf = gridx / 2;
      gridyHalf = gridy / 2;
      position = $el.position();
      offsetLeft = position.left % gridx;
      offsetTop = position.top % gridy;
      startLeft = mousex - position.left;
      startTop = mousey - position.top;
      oldPosCombined = 0;
      return function(event) {
        var left, snapx, snapy, top;

        left = event.pageX - startLeft;
        top = event.pageY - startTop;
        snapx = left % gridx;
        snapy = top % gridy;
        if (snapx >= gridxHalf) {
          left += gridx - snapx;
        } else {
          left -= snapx;
        }
        if (snapy >= gridyHalf) {
          top += gridy - snapy;
        } else {
          top -= snapy;
        }
        left += offsetLeft;
        top += offsetTop;
        if (oldPosCombined !== left + top) {
          $el.trigger('xxx-draggable-snap', [left, top]);
          oldPosCombined = left + top;
        }
        el.style.left = left + 'px';
        return el.style.top = top + 'px';
      };
    };

    return SnapDraggable;

  })(Draggable);

  Resizable = (function() {
    Resizable.create = function(el, opts) {
      var grid, margin;

      if (opts == null) {
        opts = {};
      }
      grid = opts.grid;
      margin = opts.margin;
      if (grid) {
        return new SnapResizable(el, grid.x, grid.y, margin.x, margin.y);
      } else {
        return new Resizable(el);
      }
    };

    function Resizable(el) {
      this.el = $(el).get(0);
      this.mousePos = new MousePos;
      this.addHandle();
      this.initEvents();
    }

    Resizable.prototype.addHandle = function() {
      return $(this.el).append('<div class="xxx-handle-se"></div>');
    };

    Resizable.prototype.initEvents = function() {
      var _this = this;

      $DOCUMENT.mouseup(function() {
        return _this.mousePos.stopRecording();
      });
      return $(this.el).children('.xxx-handle-se').mousedown(function(event) {
        event.stopPropagation();
        _this.mousePos.record(_this.getMousemoveCB(event.pageX, event.pageY));
        return false;
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

    function SnapResizable(el, gridx, gridy, marginx, marginy) {
      this.gridx = gridx;
      this.gridy = gridy;
      this.marginx = marginx;
      this.marginy = marginy;
      SnapResizable.__super__.constructor.call(this, el);
    }

    SnapResizable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, gridx, gridxHalf, gridy, gridyHalf, marginx, marginy, startLeft, startTop;

      el = this.el;
      $el = $(el);
      marginx = this.marginx;
      marginy = this.marginy;
      gridx = this.gridx;
      gridy = this.gridy;
      gridxHalf = gridx / 2;
      gridyHalf = gridy / 2;
      startLeft = mousex - $el.width();
      startTop = mousey - $el.height();
      return function(event) {
        var height, snapx, snapy, width;

        width = event.pageX - startLeft;
        height = event.pageY - startTop;
        snapx = width % gridx;
        snapy = height % gridy;
        if (snapx >= gridxHalf) {
          width += gridx - snapx;
        } else {
          width -= snapx;
        }
        if (snapy >= gridyHalf) {
          height += gridy - snapy;
        } else {
          height -= snapy;
        }
        width += (Math.floor(width / gridx) - 1) * marginx;
        height += (Math.floor(height / gridy) - 1) * marginy;
        el.style.width = width + 'px';
        return el.style.height = height + 'px';
      };
    };

    return SnapResizable;

  })(Resizable);

  Grid = (function() {
    function Grid(containerEl, gridx, gridy, marginx, marginy) {
      this.containerEl = containerEl;
      this.gridx = gridx;
      this.gridy = gridy;
      this.marginx = marginx != null ? marginx : 0;
      this.marginy = marginy != null ? marginy : 0;
      this.grid = [];
      this.members = [];
      this.updateMaxCol();
      this.updateOffsetLeft();
      this.initEvents();
    }

    Grid.prototype.initEvents = function() {
      var _this = this;

      return $WINDOW.resize(function() {
        var member, _i, _len, _ref, _results;

        _this.updateMaxCol();
        _this.updateOffsetLeft();
        _this.grid = [];
        _ref = _this.members;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          _results.push(_this.append(member));
        }
        return _results;
      });
    };

    Grid.prototype.sizeToRowUnit = function(size) {
      return (size - this.offsetLeft - this.marginy) / (this.marginy + this.gridy);
    };

    Grid.prototype.sizeToColUnit = function(size) {
      return (size - this.marginx) / (this.marginx + this.gridx);
    };

    Grid.prototype.rowUnitToSize = function(row) {
      return (row + 1) * this.marginy + row * this.gridy;
    };

    Grid.prototype.colUnitToSize = function(col) {
      return (col + 1) * this.marginx + col * this.gridx + this.offsetLeft;
    };

    Grid.prototype.updateMaxCol = function() {
      var containerWidth;

      containerWidth = $(this.containerEl).width();
      this.maxCol = Math.floor(this.sizeToColUnit(containerWidth)) - 1;
      if (this.maxCol < 0) {
        return this.maxCol = 0;
      }
    };

    Grid.prototype.updateOffsetLeft = function() {
      var containerWidth, gridWidth, maxElements;

      containerWidth = $(this.containerEl).width();
      maxElements = this.maxCol + 1;
      gridWidth = this.marginx + maxElements * (this.gridx + this.marginx);
      return this.offsetLeft = (containerWidth - gridWidth) / 2;
    };

    Grid.prototype.isEmpty = function(row, col) {
      if (!this.grid[row]) {
        return true;
      } else {
        return !this.grid[row][col];
      }
    };

    Grid.prototype.insertAt = function(gridMember, row, col) {
      var currentMember;

      if (!this.grid[row]) {
        this.grid[row] = [];
      }
      this.vacate(gridMember);
      currentMember = this.grid[row][col];
      if (currentMember && currentMember !== gridMember) {
        this.insertAt(currentMember, row + gridMember.sizey, col);
      }
      this.grid[row][col] = gridMember;
      return gridMember.moveTo(row, col);
    };

    Grid.prototype.vacate = function(gridMember) {
      var x, y, _i, _ref, _results;

      _results = [];
      for (y = _i = 0, _ref = gridMember.sizey; 0 <= _ref ? _i < _ref : _i > _ref; y = 0 <= _ref ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref1, _ref2, _results1;

          _results1 = [];
          for (x = _j = 0, _ref1 = gridMember.sizex; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            _results1.push((_ref2 = this.grid[gridMember.row + y]) != null ? delete _ref2[gridMember.col + x] : void 0);
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Grid.prototype.append = function(gridMember, row, col) {
      if (row == null) {
        row = 0;
      }
      if (col == null) {
        col = 0;
      }
      if (col > this.maxCol) {
        return this.append(gridMember, row + 1, 0);
      } else if (this.isEmpty(row, col)) {
        return this.insertAt(gridMember, row, col);
      } else {
        return this.append(gridMember, row, col + 1);
      }
    };

    Grid.prototype.addElement = function(el, draggable, resizable) {
      var member;

      member = new GridMember(this, el, draggable, resizable);
      this.members.push(member);
      return this.append(member);
    };

    return Grid;

  })();

  GridMember = (function() {
    function GridMember(grid, el, draggable, resizable) {
      var $el;

      this.grid = grid;
      this.el = el;
      this.draggable = draggable;
      this.resizable = resizable;
      $el = $(el);
      this.sizex = $el.data('xxx-sizex') || 1;
      this.sizey = $el.data('xxx-sizey') || 1;
      el.style.width = this.sizex * this.grid.gridx + 'px';
      el.style.height = this.sizey * this.grid.gridy + 'px';
      this.initEvents();
    }

    GridMember.prototype.initEvents = function() {
      var $el,
        _this = this;

      $el = $(this.el);
      return $el.on('xxx-draggable-snap', function(e, left, top) {
        var col, row;

        row = Math.round(_this.grid.sizeToRowUnit(top));
        col = Math.round(_this.grid.sizeToColUnit(left));
        return _this.grid.insertAt(_this, row, col);
      });
    };

    GridMember.prototype.getBelowNeighbors = function() {
      var neighbor, neighborRow, neighbors, x, _i, _ref;

      neighbors = [];
      neighborRow = this.row + this.sizey;
      if (!this.grid.isEmpty(neighborRow, this.col)) {
        for (x = _i = 0, _ref = this.sizex; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
          neighbor = this.grid.grid[neighborRow][this.col + x];
          if (neighbor) {
            neighbors.push(neighbor);
          }
        }
      }
      return neighbors;
    };

    GridMember.prototype.moveTo = function(row, col) {
      this.row = row;
      this.col = col;
      this.el.style.top = this.grid.rowUnitToSize(row) + 'px';
      return this.el.style.left = this.grid.colUnitToSize(col) + 'px';
    };

    return GridMember;

  })();

  $.fn.grida = function(opts) {
    var args, el, grid, gridElArgs, margin, _i, _j, _len, _len1, _ref, _ref1, _results;

    grid = opts.grid;
    margin = opts.margin;
    gridElArgs = [];
    _ref = this.children().get().reverse();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      gridElArgs.push([
        el, Draggable.create(el, {
          grid: grid,
          margin: margin
        }), Resizable.create(el, {
          grid: grid,
          margin: margin
        })
      ]);
    }
    grid = new Grid(this.get(), grid.x, grid.y, margin.x, margin.y);
    _ref1 = gridElArgs.reverse();
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      args = _ref1[_j];
      _results.push(grid.addElement.apply(grid, args));
    }
    return _results;
  };

}).call(this);

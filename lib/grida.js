(function() {
  var Draggable, Grid, GridElement, MousePos, Resizable,
    __slice = [].slice;

  Draggable = (function() {
    var _mousePos;

    _mousePos = new MousePos;

    function Draggable(el, grid, marginx) {
      this.grid = grid;
      this.marginx = marginx;
      this.$el = $(el);
      this.setCssAbsolute();
      this.initEvents();
    }

    Draggable.prototype.setCssAbsolute = function() {
      var $el, position;

      $el = this.$el;
      position = $el.position();
      return $el.css({
        position: 'absolute',
        left: position.left,
        top: position.top
      });
    };

    Draggable.prototype.initEvents = function() {
      var $el,
        _this = this;

      $el = this.$el;
      $(document).mouseup(function() {
        return _mousePos.stopRecording();
      });
      return $el.mousedown(function(e) {
        var grid, gridHalf, marginx, mousemove, position, startPosLeft, startPosTop;

        position = $el.position();
        startPosLeft = e.pageX - position.left;
        startPosTop = e.pageY - position.top;
        if (_this.grid) {
          grid = _this.grid;
          marginx = _this.marginx;
          gridHalf = grid / 2;
          mousemove = function(e) {
            var left, snapx, snapy, top;

            left = e.pageX - startPosLeft;
            top = e.pageY - startPosTop;
            snapx = left % grid;
            snapy = top % grid;
            if (snapx >= gridHalf) {
              left += grid - snapx;
            } else {
              left -= snapx;
            }
            if (snapy >= gridHalf) {
              top += grid - snapy;
            } else {
              top -= snapy;
            }
            return $el.css({
              left: marginx + left,
              top: marginx + top
            });
          };
        } else {
          mousemove = function(e) {
            return $el.css({
              left: e.pageX - startPosLeft,
              top: e.pageY - startPosTop
            });
          };
        }
        _mousePos.record(mousemove);
        return false;
      });
    };

    return Draggable;

  })();

  Grid = (function() {
    function Grid(unity, unitx, marginx, marginy) {
      this.unity = unity;
      this.unitx = unitx;
      this.marginx = marginx;
      this.marginy = marginy;
      this.grid = [[]];
    }

    Grid.prototype.isEmpty = function(row, col) {
      if (!this.grid[row]) {
        return true;
      }
      return !this.grid[row][col];
    };

    Grid.prototype.insertAt = function(gridElement, row, col) {
      var i, _i;

      if (!this.grid[row]) {
        for (i = _i = 0; 0 <= row ? _i <= row : _i >= row; i = 0 <= row ? ++_i : --_i) {
          if (!this.grid[i]) {
            this.grid[i] = [];
          }
        }
      }
      this.grid[row][col] = gridElement;
      return gridElement.moveTo(row, col);
    };

    Grid.prototype.append = function(gridElement, row, col) {
      if (row == null) {
        row = 0;
      }
      if (col == null) {
        col = 0;
      }
      if (this.isEmpty(row, col)) {
        return this.insertAt(gridElement, row, col);
      } else {
        return this.append(gridElement, row + 1, col + 1);
      }
    };

    return Grid;

  })();

  GridElement = (function() {
    function GridElement(grid, el, draggable, resizable) {
      this.grid = grid;
      this.el = el;
      this.draggable = draggable;
      this.resizable = resizable;
      this.sizex = parseInt(this.el.data('xxx-sizex'));
      this.sizey = parseInt(this.el.data('xxx-sizey'));
      this.el.css({
        width: this.sizex * this.grid.unitx,
        height: this.sizey * this.grid.unity
      });
    }

    GridElement.prototype.moveTo = function(row, col) {
      return this.el.css({
        left: (col + 1) * this.grid.marginx + col * this.grid.unitx,
        top: (row + 1) * this.grid.marginy + row * this.grid.unity
      });
    };

    return GridElement;

  })();

  $.fn.grida = function(opts) {
    var args, el, grid, gridElArgs, _i, _j, _len, _len1, _ref, _ref1, _results;

    gridElArgs = [];
    _ref = this.children().get().reverse();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      gridElArgs.push([$(el), new Draggable(el, opts.grid[0] + opts.margin[0], opts.margin[0]), new Resizable(el, opts.grid[0], opts.margin[0])]);
    }
    grid = new Grid(opts.grid[0], opts.grid[1], opts.margin[0], opts.margin[1]);
    _ref1 = gridElArgs.reverse();
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      args = _ref1[_j];
      _results.push(grid.append((function(func, args, ctor) {
        ctor.prototype = func.prototype;
        var child = new ctor, result = func.apply(child, args);
        return Object(result) === result ? result : child;
      })(GridElement, [grid].concat(__slice.call(args)), function(){})));
    }
    return _results;
  };

  MousePos = (function() {
    var $document;

    $document = $(document);

    function MousePos() {
      this.onMouseMove = function() {};
    }

    MousePos.prototype.record = function(callback) {
      this.onMouseMove = function(e) {
        return callback(e);
      };
      return $document.mousemove(this.onMouseMove);
    };

    MousePos.prototype.stopRecording = function() {
      return $document.unbind('mousemove', this.onMouseMove);
    };

    return MousePos;

  })();

  Resizable = (function() {
    var _mousePos;

    _mousePos = new MousePos;

    function Resizable(el, grid, marginx) {
      this.grid = grid;
      this.marginx = marginx;
      this.$el = $(el);
      this.addHandle();
      this.initEvents();
    }

    Resizable.prototype.addHandle = function() {
      this.$handle = $('<div class="xxx-handle-se"></div>');
      return this.$el.append(this.$handle);
    };

    Resizable.prototype.initEvents = function() {
      var $el,
        _this = this;

      $el = this.$el;
      $(document).mouseup(function() {
        return _mousePos.stopRecording();
      });
      return this.$handle.mousedown(function(e) {
        var grid, gridHalf, marginx, mousemove, startHeight, startWidth;

        e.stopPropagation();
        startWidth = e.pageX - $el.width();
        startHeight = e.pageY - $el.height();
        if (_this.grid) {
          grid = _this.grid;
          marginx = _this.marginx;
          gridHalf = grid / 2;
          mousemove = function(e) {
            var height, snapx, snapy, width;

            width = e.pageX - startWidth;
            height = e.pageY - startHeight;
            snapx = width % grid;
            snapy = height % grid;
            if (snapx >= gridHalf) {
              width += grid - snapx;
            } else {
              width -= snapx;
            }
            if (snapy >= gridHalf) {
              height += grid - snapy;
            } else {
              height -= snapy;
            }
            return $el.css({
              width: (Math.floor(width / grid) - 1) * marginx + width,
              height: (Math.floor(height / grid) - 1) * marginx + height
            });
          };
        } else {
          mousemove = function(e) {
            return $el.css({
              width: e.pageX - startWidth,
              height: e.pageY - startHeight
            });
          };
        }
        _mousePos.record(mousemove);
        return false;
      });
    };

    return Resizable;

  })();

}).call(this);

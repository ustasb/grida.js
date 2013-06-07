(function() {
  var $DOCUMENT, $WINDOW, Draggable, Grid, GridMember, InsertionType, MousePos, Resizable, SnapDraggable, SnapResizable,
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
    Draggable.create = function(el, grid) {
      if (grid) {
        return new SnapDraggable(el, grid);
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

    function SnapDraggable(el, grid) {
      this.grid = grid;
      SnapDraggable.__super__.constructor.call(this, el);
    }

    SnapDraggable.prototype.getMousemoveCB = function(mousex, mousey) {
      var $el, el, grid, oldRowCol, position, round, startLeft, startTop;
      el = this.el;
      $el = $(el);
      grid = this.grid;
      round = Math.round;
      position = $el.position();
      startLeft = mousex - position.left;
      startTop = mousey - position.top;
      oldRowCol = round(grid.topToRowUnit(position.top)) + 'x' + round(grid.leftToColUnit(position.left));
      return function(event) {
        var col, left, row, top;
        left = event.pageX - startLeft;
        top = event.pageY - startTop;
        row = round(grid.topToRowUnit(top));
        col = round(grid.leftToColUnit(left));
        if ((row + 'x' + col) !== oldRowCol) {
          $el.trigger('xxx-draggable-snap', [row, col]);
          oldRowCol = row + 'x' + col;
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
      var $el, el, gridx, gridxHalf, gridy, gridyHalf, marginx, marginy, oldSizeCombined, startLeft, startTop;
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
      oldSizeCombined = 0;
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
        if (oldSizeCombined !== width + height) {
          $el.trigger('xxx-resizable-snap', [width, height]);
          oldSizeCombined = width + height;
        }
        el.style.width = width + 'px';
        return el.style.height = height + 'px';
      };
    };

    return SnapResizable;

  })(Resizable);

  InsertionType = {
    TRADE: 1,
    SHIFT_DOWN: 2
  };

  Grid = (function() {
    function Grid(containerEl, gridx, gridy, marginx, marginy) {
      this.containerEl = containerEl;
      this.gridx = gridx;
      this.gridy = gridy;
      this.marginx = marginx != null ? marginx : 0;
      this.marginy = marginy != null ? marginy : 0;
      this.maxCol = 0;
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

    Grid.prototype.topToRowUnit = function(top) {
      return (top - this.marginy) / (this.marginy + this.gridy);
    };

    Grid.prototype.leftToColUnit = function(left) {
      return (left - this.offsetLeft - this.marginx) / (this.marginx + this.gridx);
    };

    Grid.prototype.rowUnitToTop = function(row) {
      return (row + 1) * this.marginy + row * this.gridy;
    };

    Grid.prototype.colUnitToLeft = function(col) {
      return (col + 1) * this.marginx + col * this.gridx + this.offsetLeft;
    };

    Grid.prototype.sizeToWidth = function(size) {
      return size * this.gridx + (size - 1) * this.marginx;
    };

    Grid.prototype.sizeToHeight = function(size) {
      return size * this.gridy + (size - 1) * this.marginy;
    };

    Grid.prototype.widthToSize = function(width) {
      return (width - this.marginx) / (this.marginx + this.gridx);
    };

    Grid.prototype.heightToSize = function(height) {
      return (height - this.marginy) / (this.marginy + this.gridy);
    };

    Grid.prototype.updateMaxCol = function() {
      var containerWidth;
      containerWidth = $(this.containerEl).width();
      this.maxCol = Math.floor(this.widthToSize(containerWidth)) - 1;
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

    Grid.prototype.get = function(row, col) {
      if (!this.grid[row]) {
        return null;
      } else {
        return this.grid[row][col];
      }
    };

    Grid.prototype.set = function(gridMember, row, col) {
      var tempRow, x, y, _i, _ref, _results;
      _results = [];
      for (y = _i = 0, _ref = gridMember.sizey; 0 <= _ref ? _i < _ref : _i > _ref; y = 0 <= _ref ? ++_i : --_i) {
        tempRow = row + y;
        if (!this.grid[tempRow]) {
          this.grid[tempRow] = [];
        }
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (x = _j = 0, _ref1 = gridMember.sizex; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            _results1.push(this.grid[tempRow][col + x] = gridMember);
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Grid.prototype.remove = function(gridMember) {
      var tempRow, x, y, _i, _ref, _results;
      if (gridMember.row === null) {
        return;
      }
      _results = [];
      for (y = _i = 0, _ref = gridMember.sizey; 0 <= _ref ? _i < _ref : _i > _ref; y = 0 <= _ref ? ++_i : --_i) {
        tempRow = gridMember.row + y;
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (x = _j = 0, _ref1 = gridMember.sizex; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
            _results1.push(delete this.grid[tempRow][gridMember.col + x]);
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Grid.prototype.isSpaceFree = function(row, col, sizex, sizey) {
      var x, y, _i, _j;
      for (y = _i = 0; 0 <= sizey ? _i < sizey : _i > sizey; y = 0 <= sizey ? ++_i : --_i) {
        for (x = _j = 0; 0 <= sizex ? _j < sizex : _j > sizex; x = 0 <= sizex ? ++_j : --_j) {
          if (this.get(row + y, col + x)) {
            return false;
          }
        }
      }
      return true;
    };

    Grid.prototype.getMembersAt = function(row, col, sizex, sizey, members) {
      var member, tempRow, x, y, _i, _j;
      if (members == null) {
        members = {};
      }
      for (y = _i = 0; 0 <= sizey ? _i < sizey : _i > sizey; y = 0 <= sizey ? ++_i : --_i) {
        tempRow = row + y;
        for (x = _j = 0; 0 <= sizex ? _j < sizex : _j > sizex; x = 0 <= sizex ? ++_j : --_j) {
          member = this.get(tempRow, col + x);
          if (member) {
            members[member.id] = member;
          }
        }
      }
      return members;
    };

    Grid.prototype.isInsertionPossibleAt = function(newMember, row, col) {
      var aboveNeighbors, member, members, newMaxCol, sizex, sizey, _;
      sizex = newMember.sizex;
      sizey = newMember.sizey;
      newMaxCol = col + (sizex - 1);
      if (col < 0 || row < 0 || newMaxCol > this.maxCol) {
        return false;
      }
      if (row === 0) {
        return InsertionType.SHIFT_DOWN;
      } else {
        members = this.getMembersAt(row, col, sizex, sizey);
        for (_ in members) {
          member = members[_];
          if (member.sizey === (row - newMember.row)) {
            return InsertionType.TRADE;
          }
        }
        aboveNeighbors = this.getMembersAt(row - 1, col, sizex, 1);
        delete aboveNeighbors[newMember.id];
        for (_ in members) {
          member = members[_];
          delete aboveNeighbors[member.id];
        }
        if ($.isEmptyObject(aboveNeighbors)) {
          return false;
        } else {
          return InsertionType.SHIFT_DOWN;
        }
      }
    };

    Grid.prototype.insertAt = function(gridMember, row, col) {
      var belowMembers, child, dy, member, membersAtNewLocation, _;
      this.remove(gridMember);
      membersAtNewLocation = this.getMembersAt(row, col, gridMember.sizex, gridMember.sizey);
      belowMembers = {};
      for (_ in membersAtNewLocation) {
        member = membersAtNewLocation[_];
        if (belowMembers[member.id]) {
          continue;
        }
        belowMembers = member.getInfluencingMembersBelow();
        belowMembers[member.id] = member;
        dy = (row - member.row) + gridMember.sizey;
        for (_ in belowMembers) {
          child = belowMembers[_];
          this.remove(child);
        }
        for (_ in belowMembers) {
          child = belowMembers[_];
          this.set(child, child.row + dy, child.col);
          child.moveTo(child.row + dy, child.col);
        }
      }
      this.set(gridMember, row, col);
      return gridMember.moveTo(row, col);
    };

    Grid.prototype.append = function(gridMember, row, col) {
      var memberMaxCol, sizex, sizey;
      if (row == null) {
        row = 0;
      }
      if (col == null) {
        col = 0;
      }
      sizex = gridMember.sizex;
      sizey = gridMember.sizey;
      memberMaxCol = col + (sizex - 1);
      if (memberMaxCol > this.maxCol) {
        if (sizex > (this.maxCol + 1) && this.isSpaceFree(row, col, sizex, sizey)) {
          return this.insertAt(gridMember, row, 0);
        } else {
          return this.append(gridMember, row + 1, 0);
        }
      } else if (this.isSpaceFree(row, col, sizex, sizey)) {
        return this.insertAt(gridMember, row, col);
      } else {
        return this.append(gridMember, row, col + 1);
      }
    };

    Grid.prototype.addElement = function(el) {
      var member;
      member = new GridMember(this, el);
      this.members.push(member);
      return this.append(member);
    };

    return Grid;

  })();

  GridMember = (function() {
    var _count;

    _count = 1;

    function GridMember(grid, el) {
      var $el;
      this.grid = grid;
      this.el = el;
      $el = $(el);
      this.id = _count++;
      this.row = null;
      this.col = null;
      this.sizex = $el.data('xxx-sizex') || 1;
      this.sizey = $el.data('xxx-sizey') || 1;
      this.resizeTo(this.sizex, this.sizey);
      this.initEvents();
    }

    GridMember.prototype.initEvents = function() {
      var $el,
        _this = this;
      $el = $(this.el);
      return $el.on('xxx-draggable-snap', function(e, row, col) {
        var member, oldChildren, _, _results;
        console.log(row, col);
        console.log(_this.grid.isInsertionPossibleAt(_this, row, col));
        oldChildren = _this.getInfluencingMembersBelow({}, false);
        switch (_this.grid.isInsertionPossibleAt(_this, row, col)) {
          case InsertionType.TRADE:
            _this.grid.remove(_this);
            for (_ in oldChildren) {
              member = oldChildren[_];
              member.collapseAboveWhiteSpace(false);
            }
            _this.grid.set(_this, row, col);
            return _this.moveTo(row, col);
          case InsertionType.SHIFT_DOWN:
            _this.grid.insertAt(_this, row, col);
            _results = [];
            for (_ in oldChildren) {
              member = oldChildren[_];
              _results.push(member.collapseAboveWhiteSpace());
            }
            return _results;
        }
      });
    };

    GridMember.prototype.collapseAboveWhiteSpace = function(recursive) {
      var aboveRow, children, dy, grid, member, _, _results;
      if (recursive == null) {
        recursive = true;
      }
      grid = this.grid;
      children = recursive ? this.getInfluencingMembersBelow({}, false) : {};
      dy = 0;
      aboveRow = this.row - 1;
      while (aboveRow >= 0 && $.isEmptyObject(grid.getMembersAt(aboveRow, this.col, this.sizex, 1))) {
        dy += 1;
        aboveRow = this.row - 1 - dy;
      }
      if (dy > 0) {
        grid.remove(this);
        grid.set(this, this.row - dy, this.col);
        this.moveTo(this.row - dy, this.col);
      }
      _results = [];
      for (_ in children) {
        member = children[_];
        _results.push(member.collapseAboveWhiteSpace(true));
      }
      return _results;
    };

    GridMember.prototype.getInfluencingMembersBelow = function(members, recursive) {
      var neighbor, neighborRow, x, _i, _ref;
      if (members == null) {
        members = {};
      }
      if (recursive == null) {
        recursive = true;
      }
      neighborRow = this.row + this.sizey;
      for (x = _i = 0, _ref = this.sizex; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        neighbor = this.grid.get(neighborRow, this.col + x);
        if (neighbor) {
          members[neighbor.id] = neighbor;
          if (recursive) {
            neighbor.getInfluencingMembersBelow(members);
          }
        }
      }
      return members;
    };

    GridMember.prototype.moveTo = function(row, col) {
      this.row = row;
      this.col = col;
      this.el.style.top = this.grid.rowUnitToTop(row) + 'px';
      return this.el.style.left = this.grid.colUnitToLeft(col) + 'px';
    };

    GridMember.prototype.resizeTo = function(sizex, sizey) {
      this.sizex = sizex;
      this.sizey = sizey;
      this.el.style.width = this.grid.sizeToWidth(sizex) + 'px';
      return this.el.style.height = this.grid.sizeToHeight(sizey) + 'px';
    };

    return GridMember;

  })();

  $.fn.grida = function(opts) {
    var children, el, grid, _i, _j, _len, _len1, _ref, _results;
    grid = new Grid(this.get(), opts.grid.x, opts.grid.y, opts.margin.x, opts.margin.y);
    children = this.children().get().reverse();
    for (_i = 0, _len = children.length; _i < _len; _i++) {
      el = children[_i];
      Draggable.create(el, grid);
    }
    _ref = children.reverse();
    _results = [];
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      el = _ref[_j];
      _results.push(grid.addElement(el));
    }
    return _results;
  };

}).call(this);

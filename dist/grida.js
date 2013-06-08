(function() {
  var $DOCUMENT, $WINDOW, Grid;

  $WINDOW = $(window);

  $DOCUMENT = $(document);

  Grid = (function() {
    function Grid(gridx, gridy, marginx, marginy) {
      this.grid = [[]];
      this.gridx = function() {
        return gridx;
      };
      this.gridy = function() {
        return gridy;
      };
      this.marginx = function() {
        return marginx;
      };
      this.marginy = function() {
        return marginy;
      };
    }

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
        for (x = _j = 0; _j < sizex; x = _j += 1) {
          if (grid[tempRow]) {
            item = grid[tempRow][col + x];
            if (item && inArray(item, items) === -1) {
              items.push(item);
            }
          } else {
            break;
          }
        }
      }
      return items;
    };

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
        throw 'col, row, sizex and sizey cannot be negative';
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

    return Grid;

  })();

}).call(this);

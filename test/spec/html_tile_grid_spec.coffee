describe 'An HTMLTileGrid class', ->
  grid = null
  $container = $(document.createElement('div'))

  beforeEach ->
    grid = new HTMLTileGrid($container, 10, 20, 5, 15)

  describe 'conversion utilities', ->

    describe '#colToLeft', ->
      it 'converts a column unit to a CSS left position', ->
        expect(grid.colToLeft(-3)).toEqual(-40)
        expect(grid.colToLeft(-2)).toEqual(-25)
        expect(grid.colToLeft(-1)).toEqual(-10)
        expect(grid.colToLeft(0)).toEqual(5)
        expect(grid.colToLeft(1)).toEqual(20)
        expect(grid.colToLeft(2)).toEqual(35)
        expect(grid.colToLeft(3)).toEqual(50)

    describe '#leftToCol', ->
      it 'converts a CSS left position to a column unit', ->
        expect(grid.leftToCol(-40)).toEqual(-3)
        expect(grid.leftToCol(-25)).toEqual(-2)
        expect(grid.leftToCol(-10)).toEqual(-1)
        expect(grid.leftToCol(5)).toEqual(0)
        expect(grid.leftToCol(20)).toEqual(1)
        expect(grid.leftToCol(35)).toEqual(2)
        expect(grid.leftToCol(50)).toEqual(3)

    describe '#rowToTop', ->
      it 'converts a row unit to a CSS top position', ->
        expect(grid.rowToTop(-3)).toEqual(-90)
        expect(grid.rowToTop(-2)).toEqual(-55)
        expect(grid.rowToTop(-1)).toEqual(-20)
        expect(grid.rowToTop(0)).toEqual(15)
        expect(grid.rowToTop(1)).toEqual(50)
        expect(grid.rowToTop(2)).toEqual(85)
        expect(grid.rowToTop(3)).toEqual(120)

    describe '#topToRow', ->
      it 'converts a CSS top position to a row unit', ->
        expect(grid.topToRow(-90)).toEqual(-3)
        expect(grid.topToRow(-55)).toEqual(-2)
        expect(grid.topToRow(-20)).toEqual(-1)
        expect(grid.topToRow(15)).toEqual(0)
        expect(grid.topToRow(50)).toEqual(1)
        expect(grid.topToRow(85)).toEqual(2)
        expect(grid.topToRow(120)).toEqual(3)

    describe '#sizeToWidth', ->
      it 'converts a grid sizex to a pixel width', ->
        expect(-> grid.sizeToWidth(-1)).toThrow()

        expect(grid.sizeToWidth(0)).toEqual(0)
        expect(grid.sizeToWidth(1)).toEqual(10)
        expect(grid.sizeToWidth(2)).toEqual(25)
        expect(grid.sizeToWidth(3)).toEqual(40)

    describe '#widthToSize', ->
      it 'converts a pixel width to a grid sizex', ->
        expect(-> grid.widthToSize(-1)).toThrow()

        expect(grid.widthToSize(0)).toEqual(0)
        expect(grid.widthToSize(10)).toEqual(1)
        expect(grid.widthToSize(25)).toEqual(2)
        expect(grid.widthToSize(40)).toEqual(3)

    describe '#sizeToHeight', ->
      it 'converts a grid sizey to a pixel height', ->
        expect(-> grid.sizeToHeight(-1)).toThrow()

        expect(grid.sizeToHeight(0)).toEqual(0)
        expect(grid.sizeToHeight(1)).toEqual(20)
        expect(grid.sizeToHeight(2)).toEqual(55)
        expect(grid.sizeToHeight(3)).toEqual(90)

    describe '#heightToSize', ->
      it 'converts a pixel height to a grid sizey', ->
        expect(-> grid.heightToSize(-1)).toThrow()

        expect(grid.heightToSize(0)).toEqual(0)
        expect(grid.heightToSize(20)).toEqual(1)
        expect(grid.heightToSize(55)).toEqual(2)
        expect(grid.heightToSize(90)).toEqual(3)

  describe '#getMaxCol', ->
    it "calculates the container's maximum column", ->
      $container.width(0)
      expect(grid.getMaxCol()).toEqual(0)

      $container.width(5)
      expect(grid.getMaxCol()).toEqual(0)

      $container.width(20)
      expect(grid.getMaxCol()).toEqual(0)

      $container.width(35)
      expect(grid.getMaxCol()).toEqual(1)

      $container.width(100)
      expect(grid.getMaxCol()).toEqual(5)

      $container.width(500)
      expect(grid.getMaxCol()).toEqual(32)

  describe '#getCenteringOffset', ->
    it 'calculates left offset required to center the grid', ->
      $container.width(0)
      expect(grid.getCenteringOffset()).toEqual(0)

      $container.width(5)
      expect(grid.getCenteringOffset()).toEqual(0)

      $container.width(20)
      expect(grid.getCenteringOffset()).toEqual(0)

      $container.width(22)
      expect(grid.getCenteringOffset()).toEqual(1)

      $container.width(30)
      expect(grid.getCenteringOffset()).toEqual(5)

      $container.width(35)
      expect(grid.getCenteringOffset()).toEqual(0)

      $container.width(100)
      expect(grid.getCenteringOffset()).toEqual(2.5)

      $container.width(500)
      expect(grid.getCenteringOffset()).toEqual(0)

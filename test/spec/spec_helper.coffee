beforeEach ->

  @addMatchers

    # Compares 2D arrays, ignoring empty (null, undefined) positions.
    toLookLike: do ->

      looksLike = (a, b) ->
        for row, y in a by 1
          if row?
            for item, x in row by 1
              if item? and (b[y]? is false or item isnt b[y][x])
                return false
        true

      (expected) ->
        if not $.isArray(@actual) or not $.isArray(expected)
          throw 'Matcher toLookLike() can only compare arrays.'

        looksLike(@actual, expected) and looksLike(expected, @actual)

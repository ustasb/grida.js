module.exports = (grunt) ->

  buildOrder = [
    'src/constants.coffee'
    'src/mouse_position.coffee'
    'src/draggable.coffee'
    'src/resizable.coffee'
    'src/grid.coffee'
    'src/tile_grid.coffee'
    'src/tile.coffee'
    'src/plugin.coffee'
  ]

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    dist:
      dev: 'dist/<%= pkg.name %>.js'
      min: 'dist/<%= pkg.name %>.min.js'
      test: 'test/<%= pkg.name %>.bare.js'

    watch:
      src:
        files: ['src/**/*.coffee']
        tasks: ['coffee:join', 'coffee:bare']
      spec:
        files: ['test/spec/**/*.coffee']
        tasks: ['coffee:spec']

    coffee:
      join:
        options:
          join: true
        files:
          '<%= dist.dev %>': buildOrder
      bare:
        options:
          bare: true
        files:
          '<%= dist.test %>': buildOrder
      spec:
        files:
          'test/specs_combined.js': ['test/spec/spec_helper.coffee',
                                     'test/spec/**/*.coffee']

    uglify:
      min:
        files:
          '<%= dist.min %>': '<%= dist.dev %>'

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-uglify')

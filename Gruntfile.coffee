module.exports = (grunt) ->

  grunt.initConfig
    watch:
      coffee:
        files: ['src/*.coffee']
        tasks: ['coffee']
    coffee:
      compile:
        options:
          join: true
        files:
          'lib/grida.js': ['src/constants.coffee'
                           'src/mouse_position.coffee',
                           'src/draggable.coffee',
                           'src/resizable.coffee',
                           'src/grid.coffee',
                           'src/plugin.coffee']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

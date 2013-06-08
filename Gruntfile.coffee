module.exports = (grunt) ->

  grunt.initConfig
    watch:
      src:
        files: ['src/*.coffee']
        tasks: ['coffee:src']
      spec:
        files: ['spec/*.coffee']
        tasks: ['coffee:spec', 'jasmine']

    coffee:
      src:
        options:
          join: true
          bare: true
        files:
          'dist/grida.js': ['src/constants.coffee'
                            'src/mouse_position.coffee'
                            'src/draggable.coffee'
                            'src/resizable.coffee'
                            'src/grid.coffee'
                            'src/plugin.coffee']
      spec:
        files:
          'spec/specs_combined.js': ['spec/*.coffee']

    jasmine:
      src: 'dist/grida.js'
      options:
        version: '1.3.1'
        keepRunner: true
        specs: 'spec/specs_combined.js'
        vendor: 'vendor/jquery*.js'


  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jasmine')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', ['watch'])

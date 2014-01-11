
module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.registerTask('test', ['coffee:compile']);

  grunt.initConfig 
    coffee: 
      compile:
        expand: true,
        flatten: true,
        cwd: 'src',
        src: ['*.coffee'],
        dest: 'lib',
        ext: '.js'
      compileCollections:
        expand: true,
        flatten: true,
        cwd: 'src/collections',
        src: ['*.coffee'],
        dest: 'lib/collections',
        ext: '.js'
      compileModels:
        expand: true,
        flatten: true,
        cwd: 'src/models',
        src: ['*.coffee'],
        dest: 'lib/models',
        ext: '.js'
 


#console.log coffee
module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    meta:
      dest: 'app'
      static : 'app'
      banner: """
      /*
        <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("d/m/yyyy") %>

        Author: <%= pkg.author.name %> - <%= pkg.author.email %>
      */

      """
    src:
      coffee : [
        "src/coffee/api.coffee"
        "src/coffee/app.coffee"]
      stylus : [
        "src/stylus/*.styl"]
      jade   : [
        "src/jade/app.jade"]
      jade_files : [
        "src/jade/*.jade"]
    # jade :
    #   build:
    #     options:
    #       data:
    #         debug : true
    #       pretty: true
    #     files:
    #       "<%=meta.dest%>/index.html" : "<%=src.jade%>"

    concat :
      coffee :
        files:
          ".tmp/coffee/tmp.coffee" : "<%=src.coffee%>"

    coffee:
      build:
        files:
          '<%=meta.static%>/<%=pkg.name%>.js' : '.tmp/coffee/tmp.coffee'

    # stylus:
    #   tmp:
    #     options:
    #       compress: false
    #     files:
    #       '<%=meta.static%>/css/<%=pkg.name%>.css' : '<%=src.stylus%>'

    uglify:
      options:
        banner: '<%= meta.banner %>'
      build:
        files:
          '<%=meta.static%>/js/<%=pkg.name%>.js' : ['<%=meta.static%>/js/<%=pkg.name%>.debug.js']

    watch :
      main :
        files : ["gruntfile.coffee"]
        tasks : ["default"]
      coffee :
        files : ["<%=src.coffee%>"]
        tasks : ["concat","coffee", "uglify"]
      stylus :
        files : ["<%=src.stylus%>"]
        tasks : ["stylus"]
      jade :
        files : ["<%=src.jade%>","<%=src.jade_files%>"]
        tasks : ["jade"]
    
  grunt.registerTask "default", [ "concat", "coffee" ]

#global module:false

# Note: this Gruntfile is only for lineman's internal development
#  and, unlike almost everything else to do with Grunt, is not intended
#  for use by people's Lineman projects.
#
# Running internal grunt commands requires the --gruntfile option
#
#   $ grunt --gruntfile Gruntfile.internal.coffee

"use strict"
markdown = require("marked")
semver = require("semver")
module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    pkgFile: 'package.json'

    release:
      options:
        commitMessage: "<%= version %>"
        tagName: "v<%= version %>"
        npm: false, # don't register to npm, only bower
        bump: false # we have our own bump
        file: "bower.json"

    stage:
      options:
        files: ["CHANGELOG.md"]

  grunt.registerTask "bump", "bump manifest version", (type) ->
    setup = (file, type) ->
      pkg = grunt.file.readJSON(file)
      newVersion = pkg.version = semver.inc(pkg.version, type or "patch")
      file: file
      pkg: pkg
      newVersion: newVersion

    # bumping package.json
    config = setup("package.json", type)
    grunt.file.write config.file, JSON.stringify(config.pkg, null, "  ") + "\n"
    grunt.log.ok "package.json version bumped to " + config.newVersion

    # bumping bower.json
    bower = setup("bower.json", type)
    grunt.file.write bower.file, JSON.stringify(bower.pkg, null, "  ") + "\n"

    grunt.log.ok "bower.json version bumped to " + bower.newVersion
    return

  grunt.registerTask "stage", "git add files before running the release task", ->
    files = @options().files
    grunt.util.spawn
      cmd: (if process.platform is "win32" then "git.cmd" else "git")
      args: ["add"].concat(files)
    , grunt.task.current.async()
    return

  grunt.registerTask "default", [
    "bump"
    "changelog"
    "stage"
  ]
  return


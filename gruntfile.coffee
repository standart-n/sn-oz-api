
'use strict'

module.exports = (grunt) ->

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')

		coffee:			
			sn:
				options:
					bare: on
				files: [
					{
						expand:			true
						cwd:			'./app/'
						src:			'**/*.coffee'
						dest:			'./script/'
						ext:			'.js'
					}
				]
			app:
				options:
					bare: on
				src: 'app/app.coffee'
				dest: './app.js'


	grunt.loadNpmTasks 'grunt-contrib-coffee'
	
	grunt.registerTask 'default', ['coffee:app', 'coffee:sn']
	grunt.registerTask 'all', ['default']


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
			server:
				options:
					bare: on
				src: 'app/server.coffee'
				dest: 'server'


	grunt.loadNpmTasks 'grunt-contrib-coffee'
	
	grunt.registerTask 'default', ['coffee:server', 'coffee:sn']
	grunt.registerTask 'all', ['default']

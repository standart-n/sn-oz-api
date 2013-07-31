
readline = 		require('readline')
path = 			require('path')
fs = 			require('fs')
_ = 			require('underscore')

rl = readline.createInterface
	input: 	process.stdin
	output:	process.stdout

module.exports = class Settings

	options: {}

	defaults:
		data: {}
		path: './settings.json'

	constructor: (attr) ->
		if typeof attr is 'string' then @options.path = attr else @options = attr
		_.defaults @options, @defaults
		@exists

	exists: () ->
		@write() if !fs.existsSync(@options.path)
		@read()

	write: () ->
		fs.writeFileSync(@options.path, JSON.stringify(@options.data))

	read: () ->
		if fs.existsSync(@options.path)
			@options.data = JSON.parse(fs.readFileSync(@options.path))

	get: (key = '') ->
		@read()
		@options.data[key] ?= off

	set: (key = '', value = '') ->
		@read()
		@options.data[key] = value
		@write()
		@options.data

	question: (key = '', question, callback) ->
		question ?= 'what?'
		rl.question question, (value) =>
			@set key, value
			callback if callback
			rl.close()




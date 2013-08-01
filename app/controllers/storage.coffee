
colors = 		require('colors')
path = 			require('path')
fs = 			require('fs')
_ = 			require('underscore')

class Storage

	options: {}

	defaults:
		data: {}
		path: './settings.json'

	store: (attr) ->
		if !attr? or attr is '' then attr = @defaults.path
		if typeof attr is 'string' then @options.path = attr else @options = attr
		_.defaults @options, @defaults
		@check()

	check: () ->
		@write() if !fs.existsSync(@options.path)
		@read()

	write: () ->
		fs.writeFileSync(@options.path, JSON.stringify(@options.data))

	read: () ->
		if fs.existsSync(@options.path)
			@options.data = JSON.parse(fs.readFileSync(@options.path))

	get: (key = '') ->
		@check()
		@options.data[key] ?= off

	set: (key = '', value = '') ->
		@check()
		@options.data[key] = value
		@write()
		if @options.data[key] is value then true else false

	remove: (key = '') ->
		@check()
		delete @options.data[key]
		@write()
		true

	export: () ->
		@check()
		@options.data ?= off

	import: (data) ->
		@check()
		@options.data = data
		@write()
		if @options.data? then true else false

	question: (rl, key = '', answer, callback) ->
		if rl? and typeof rl isnt 'string' and key? and typeof key is 'string'
			if typeof answer isnt 'string'
				callback = answer if answer?
				answer = 'please input '.grey + key.blue + ': '.grey + '\n'
			rl.question answer, (value) =>
				@set key, value
				callback(value) if callback?
				#rl.close()

module.exports = new Storage()

exports.Storage = Storage


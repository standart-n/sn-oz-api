
module.exports = (program, storage) ->

	throw 'program is not exists' if !program?
	throw 'storage is not exists' if !storage?

	program
		.command('set <key> <value>')
		.description('set settings')
		.action (key,value) ->
			console.log storage.set(key, value)
			process.exit()

	program
		.command('get <key>')
		.description('get settings')
		.action (key) ->
			console.log storage.get(key)
			process.exit()

	program
		.command('remove <key>')
		.description('remove settings')
		.action (key) ->
			console.log storage.remove(key)
			process.exit()

	program
		.command('import <data>')
		.description('import data into settings')
		.action (data) ->
			console.log storage.import(data)
			process.exit()

	program
		.command('export')
		.description('export data from settings')
		.action () ->
			console.log storage.export()
			process.exit()

	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver-conf set port 2244'
		console.log '    $ ozserver-conf get mongodb_connection'
		console.log ''




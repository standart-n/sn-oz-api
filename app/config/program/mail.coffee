
module.exports = (program, store) ->

	throw 'program is not exists' if !program?
	throw 'store is not exists' if !store?

	program
		.command('set <key> <value>')
		.description('set settings')
		.action (key,value) ->
			console.log store.set(key, value)
			process.exit()

	program
		.command('get <key>')
		.description('get settings')
		.action (key) ->
			console.log store.get(key)
			process.exit()

	program
		.command('remove <key>')
		.description('remove settings')
		.action (key) ->
			console.log store.remove(key)
			process.exit()

	program
		.command('import <data>')
		.description('import data into settings')
		.action (data) ->
			console.log store.import(data)
			process.exit()

	program
		.command('export')
		.description('export data from settings')
		.action () ->
			console.log store.export()
			process.exit()

	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver-mail set email office@standart-n.ru'
		console.log '    $ ozserver-mail get host'
		console.log ''




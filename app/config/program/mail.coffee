
mkpath = 				require('mkpath')
store = 				require(global.home + '/script/controllers/storage')

module.exports = (program) ->

	throw 'program is not exists' 	if !program?
	throw 'store is not exists' 	if !store?

	init = (program) ->
		if program.profile?
			mkpath.sync 			"/usr/lib/ozserver/#{program.profile}"
			global.mail = 			"/usr/lib/ozserver/#{program.profile}/mail.json"
		store.store(global.mail)

	program
		.option('-P, --profile <name>', 'profile for settings in /usr/lib/ozserver')

	program
		.command('set <key> <value>')
		.description('set settings')
		.action (key,value) ->
			init(program)
			console.log store.set(key, value)
			process.exit()

	program
		.command('get <key>')
		.description('get settings')
		.action (key) ->
			init(program)
			console.log store.get(key)
			process.exit()

	program
		.command('remove <key>')
		.description('remove settings')
		.action (key) ->
			init(program)
			console.log store.remove(key)
			process.exit()

	program
		.command('import <data>')
		.description('import data into settings')
		.action (data) ->
			init(program)
			console.log store.import(data)
			process.exit()

	program
		.command('export')
		.description('export data from settings')
		.action () ->
			init(program)
			console.log store.export()
			process.exit()

	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver-mail set email office@standart-n.ru'
		console.log '    $ ozserver-mail get host'
		console.log ''





module.exports = (program, server) ->

	throw 'program is not exists' if !program?
	throw 'server is not exists' if !server?

	program
		.command('run')
		.description('run server')
		.action () ->
			global.command = 'run'
			server.run()


module.exports = (program, server) ->

	throw 'program is not exists' 		if !program?
	throw 'server is not exists' 		if !server?

	program
		.option('-c, --connection <string>', 'connection string to mongodb')
		.option('-p, --port <port>', 'port for server', parseInt)
		.option('-P, --profile', 'profile for settings in /usr/lib/ozserver')

	program
		.command('run')
		.description('run server')
		.action () ->

			global.command = 'run'
			server.run
				port: 					if program.port? 		then program.port 			else null
				connection: 			if program.connection? 	then program.connection 	else null
				profile: 				if program.profile? 	then program.profile 		else null

	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver run'
		console.log ''


colors = 				require('colors')
cluster = 				require('cluster')
http = 					require('http')
numCPUs = 				require('os').cpus()
server = 				require(global.home + '/script/controllers/server')

module.exports = (program) ->
	

	throw 'program is not exists' 		if !program?
	throw 'server is not exists' 		if !server?

	program
		.option('-c, --connection <string>', 'connection string to mongodb')
		.option('-p, --port <port>', 'port for server', parseInt)
		.option('-P, --profile <name>', 'profile for settings in /usr/lib/ozserver')

	program
		.command('run')
		.description('run server')
		.action () ->

			global.command = 'run'
			server.run
				port: 					if program.port? 		then program.port 			else null
				connection: 			if program.connection? 	then program.connection 	else null
				profile: 				if program.profile? 	then program.profile 		else null

				create:	(app, options) ->

					if cluster.isMaster

						cluster.setupMaster
							exec:			"#{global.home}/ozserver"
							args:			["run"]
							silent: 		false

						for i in numCPUs
							cluster.fork()
							
						cluster.on 'exit', (worker, code, signal) ->
							console.log "worker #{worker.process.pid} died"

					else

						service = http.createServer(app)

						service.listen options.port, () ->
							console.log "server work at ".grey + "http://localhost:#{options.port.toString()}".blue





	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver run'
		console.log ''

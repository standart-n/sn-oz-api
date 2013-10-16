
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

			if cluster.isMaster

				server.configure
					port: 				if program.port? 			then program.port 			else null
					connection: 		if program.connection? 		then program.connection 	else null
					profile: 			if program.profile? 		then program.profile 		else null
				
				, (results) ->

					args = ["run"]

					console.log "server work at ".grey + "http://localhost:#{results[0].toString()}".blue

					if program.port?
						args.push 		'--port'
						args.push 		program.port

					if program.connection?
						args.push 		'--connection'
						args.push 		program.connection

					if program.profile?
						args.push 		'--profile'
						args.push 		program.profile

					cluster.setupMaster
						exec:			"#{global.home}/ozserver"
						args:			args
						silent: 		false

					# for i in numCPUs
					cluster.fork()
						
					cluster.on 'exit', (worker, code, signal) ->
						console.log "worker #{worker.process.pid} died"


			if cluster.isWorker

				process.on 'uncaughtException', (err) ->
					console.error 'Caught exception:'.red, JSON.stringify(err).blue

				server.run
					port: 					if program.port? 		then program.port 			else null
					connection: 			if program.connection? 	then program.connection 	else null
					profile: 				if program.profile? 	then program.profile 		else null

				, (service, options) ->

					service.listen options.port


	program.on '--help', () ->
		console.log '  Examples:'
		console.log ''
		console.log '    $ ozserver run'
		console.log ''

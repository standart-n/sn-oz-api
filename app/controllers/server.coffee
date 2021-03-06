
express = 													require('express')
mongoose = 													require('mongoose')
http = 														require('http')
path = 														require('path')
mkpath = 													require('mkpath')
colors = 													require('colors')
readline = 													require('readline')
async = 													require('async')
cluster = 													require('cluster')
_ = 														require('lodash')

Storage = 													require(global.home + '/script/controllers/storage').Storage
Streak = 													require(global.home + '/script/controllers/streak').Streak

class Server

	constructor: () ->

	configure: (special = {}, handler) ->

		@options =
			mail: {}

		throw 'global.store is not exists' 					if !global.store?
		throw 'global.mail is not exists' 					if !global.mail?

		if special.profile? 			
			mkpath.sync 									"/usr/lib/ozserver/#{special.profile}"
			global.store = 									"/usr/lib/ozserver/#{special.profile}/store.json"
			global.mail = 									"/usr/lib/ozserver/#{special.profile}/mail.json"


		@options = _.extend {}, @options, special

		@store = 											new Storage(global.store)
		@mail = 											new Storage(global.mail)

		if cluster.isMaster

			@rl = readline.createInterface
				input: 										process.stdin
				output:										process.stdout

		async.series [

			(callback) =>									@answer 	@store, 	'port',						callback
			(callback) =>									@answer 	@store, 	'mongodb_connection',		callback
			(callback) =>									@answer 	@store, 	'uploads_directory',		callback
			(callback) =>									@answer 	@store, 	'uploads_url',				callback
			(callback) =>									@answer 	@store, 	'max_user_file_size_mb',	callback
			(callback) =>									@answer 	@mail, 		'email',					callback
			(callback) =>									@answer 	@mail, 		'host',						callback
			(callback) =>									@answer 	@mail, 		'user',						callback
			(callback) =>									@answer 	@mail, 		'password',					callback

		], (err, results) =>
			@rl.close() 									if cluster.isMaster
			handler(results)								if typeof handler is 'function'

	answer: (conf, key, callback) ->
		if !@options[key]? and !conf.get(key)
			throw 'rl not defined'							if !@rl?
			conf.question @rl, key, (value) ->
				callback(null, value)
		else
			if !@options[key]
				callback null, conf.get(key)
			else 
				callback null, @options[key]



	run: (special = {}, handler) ->

		@configure special, (results) =>

			@options.port = 								results[0]
			@options.mongodb_connection = 					results[1]

			@options.uploads_directory = 					results[2]
			@options.uploads_url = 							results[3]
			@options.max_user_file_size_mb = 				results[4]

			@options.mail.host = 							results[5]
			@options.mail.user = 							results[6]
			@options.mail.password = 						results[7]

			app = express()

			if !@options.mongodb_connection? or @options.mongodb_connection is ''
				throw 'undefined mongodb_connection'

			mongoose.connect(@options.mongodb_connection)

			mongoose.connection.on 'error', (err) ->
				throw err if err


			# streak between routes and sockeets
			streak = new Streak()

			# settings
			require(global.home + '/script/config/express/server'	)(app, @options, streak)
	
			# routes
			require(global.home + '/script/routes/registration'		)(app, @options, streak)
			require(global.home + '/script/routes/remember'			)(app, @options, streak)
			require(global.home + '/script/routes/action'			)(app, @options, streak)
			require(global.home + '/script/routes/signin'			)(app, @options, streak)
			require(global.home + '/script/routes/edit'				)(app, @options, streak)
			require(global.home + '/script/routes/feed'				)(app, @options, streak)

			if !app.get('port')? or app.get('port') is ''
				throw 'undefined port'


			server = http.createServer(app)

			# if cluster.isWorker and cluster.worker.id is 1
			require(global.home + '/script/controllers/sockets')(server, streak)
			
			require(global.home + '/script/controllers/movement')(streak)

			handler(server, @options) if typeof handler is 'function'

			# server.listen app.get('port'), () ->
			# 	console.log "server work at ".grey + "http://localhost:#{app.get('port').toString()}".blue



exports = module.exports = new Server()

exports.Server = Server

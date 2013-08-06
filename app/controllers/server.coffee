
express = 				require('express')
mongoose = 				require('mongoose')
http = 					require('http')
path = 					require('path')
colors = 				require('colors')
readline = 				require('readline')
async = 				require('async')
_ = 					require('underscore')

storage = 				require(global.home + '/script/controllers/storage')			# storage.js

storage.store(global.store)

rl = readline.createInterface
	input: 	process.stdin
	output:	process.stdout


class Server

	options: {}

	configure: (handler) ->

		async.series [
			(callback) ->
				if !storage.get('port')
					storage.question rl, 'port', (value) ->
						callback null, value
				else 
					callback null, storage.get('port')
			(callback) ->
				if !storage.get('mongodb_connection')
					storage.question rl, 'mongodb_connection', (value) ->
						callback(null, value)
				else 
					callback null, storage.get('mongodb_connection')
		], (err, results) ->
			rl.close()
			handler(results)

	run: () ->

		@configure (results) =>
			@options.port = 					results[0]
			@options.mongodb_connection = 		results[1]

			app = express()

			mongoose.connect(@options.mongodb_connection)

			# settings
			require(global.home + '/script/config/express/server')(app, @options)

			# routes
			require(global.home + '/script/routes/registration')(app, @options)
			require(global.home + '/script/routes/signin')(app, @options)

			http.createServer(app).listen app.get('port'), () ->
				console.log "server work at ".grey + "http://localhost: ".grey + app.get('port').blue


module.exports = new Server()

exports.Server = Server




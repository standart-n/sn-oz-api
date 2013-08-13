
express = 													require('express')
mongoose = 													require('mongoose')
http = 														require('http')
path = 														require('path')
colors = 													require('colors')
readline = 													require('readline')
async = 													require('async')
_ = 														require('underscore')

Storage = 													require(global.home + '/script/controllers/storage').Storage


rl = readline.createInterface
	input: 													process.stdin
	output:													process.stdout


class Server

	constructor: () ->

		@options =
			mail: {}

		@store = 											new Storage(global.store)
		@mail = 											new Storage(global.mail)


	configure: (handler) ->

		async.series [

			(callback) =>									@answer(@store,'port',callback)
			(callback) =>									@answer(@store,'mongodb_connection',callback)
			(callback) =>									@answer(@mail,'host',callback)
			(callback) =>									@answer(@mail,'user',callback)
			(callback) =>									@answer(@mail,'password',callback)

		], (err, results) ->
			rl.close()
			handler(results)

	answer: (conf, key, callback) ->
		if !conf.get(key)
			conf.question rl, key, (value) ->
				callback(null, value)
		else 
			callback null, conf.get(key)


	run: () ->

		@configure (results) =>
			@options.port = 								results[0]
			@options.mongodb_connection = 					results[1]

			@options.mail.host = 							results[2]
			@options.mail.user = 							results[3]
			@options.mail.password = 						results[4]

			app = express()

			mongoose.connect(@options.mongodb_connection)

			# settings
			require(global.home + '/script/config/express/server')(app, @options)

			# routes
			require(global.home + '/script/routes/registration')(app, @options)
			require(global.home + '/script/routes/signin')(app, @options)
			require(global.home + '/script/routes/edit')(app, @options)
			require(global.home + '/script/routes/feed')(app, @options)

			http.createServer(app).listen app.get('port'), () ->
				console.log "server work at ".grey + "http://localhost: ".grey + app.get('port').blue


exports = module.exports = new Server()

exports.Server = Server




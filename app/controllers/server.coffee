
express = 													require('express')
mongoose = 													require('mongoose')
http = 														require('http')
path = 														require('path')
mkpath = 													require('mkpath')
colors = 													require('colors')
readline = 													require('readline')
async = 													require('async')
_ = 														require('underscore')

Storage = 													require(global.home + '/script/controllers/storage').Storage
Middlevent = 												require(global.home + '/script/controllers/middlevent').Middlevent


rl = readline.createInterface
	input: 													process.stdin
	output:													process.stdout


class Server

	constructor: () ->


	configure: (handler) ->

		async.series [

			(callback) =>									@answer(@store,'port',callback)
			(callback) =>									@answer(@store,'mongodb_connection',callback)
			(callback) =>									@answer(@mail,'email',callback)
			(callback) =>									@answer(@mail,'host',callback)
			(callback) =>									@answer(@mail,'user',callback)
			(callback) =>									@answer(@mail,'password',callback)

		], (err, results) ->
			rl.close()
			handler(results)

	answer: (conf, key, callback) ->
		if !conf.get(key) and !@options[key]?
			throw 'rl not defined'							if !rl?
			conf.question rl, key, (value) ->
				callback(null, value)
		else
			if !@options[key]
				callback null, conf.get(key)
			else 
				callback null, @options[key]



	run: (special = {}) ->

		@options =
			mail: {}

		throw 'global.store is not exists' 					if !global.store?
		throw 'global.mail is not exists' 					if !global.mail?

		if special.profile? 			
			mkpath.sync 									"/usr/lib/ozserver/#{special.profile}"
			global.store = 									"/usr/lib/ozserver/#{special.profile}/store.json"
			global.mail = 									"/usr/lib/ozserver/#{special.profile}/mail.json"

		@store = 											new Storage(global.store)
		@mail = 											new Storage(global.mail)

		if special.port? 			then @options.port = special.port
		if special.connection? 		then @options.mongodb_connection = special.connection

		@configure (results) =>
			@options.port = 								results[0]
			@options.mongodb_connection = 					results[1]

			@options.mail.host = 							results[2]
			@options.mail.user = 							results[3]
			@options.mail.password = 						results[4]

			app = express()

			if !@options.mongodb_connection? or @options.mongodb_connection is ''
				throw 'undefined mongodb_connection'

			mongoose.connect(@options.mongodb_connection)

			mongoose.connection.on 'error', (err) ->
				console.log err if err

			# settings
			require(global.home + '/script/config/express/server'	)(app, @options, middlevent)

			# routes
			middlevent = new Middlevent()
	
			require(global.home + '/script/routes/registration'		)(app, @options)
			require(global.home + '/script/routes/remember'			)(app, @options)
			require(global.home + '/script/routes/signin'			)(app, @options)
			require(global.home + '/script/routes/edit'				)(app, @options)
			require(global.home + '/script/routes/feed'				)(app, @options, middlevent)

			if !app.get('port')? or app.get('port') is ''
				throw 'undefined port'


			server = http.createServer(app)

			server.listen app.get('port'), () ->
				console.log "server work at ".grey + "http://localhost:#{app.get('port').toString()}".blue


			require(global.home + '/script/controllers/sockets')(server, middlevent)



exports = module.exports = new Server()

exports.Server = Server

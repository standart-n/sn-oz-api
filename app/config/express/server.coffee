
express = 										require('express')
logger = 										require(global.home + '/script/config/express/logger')

module.exports = (app, options) ->

	app.configure ->
		app.set 'port', process.env.PORT || options.port.toString()

		app.use express.logger logger

		app.use '/upload', (req, res, next) ->

			require(global.home + '/script/controllers/upload')(req, res, next).emit('upload')


		app.use express.bodyParser()

		app.use express.methodOverride()

		app.use app.router

		app.use express.static global.home + '/public'

		app.configure 'development', () ->
			app.use express.errorHandler()

		app.all '*', (req, res, next) ->	
			req.method = req.query._method if req.query._method?
			next()

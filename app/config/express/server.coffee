
express = 				require('express')

module.exports = (app, options) ->

	app.configure ->
		app.set 'port', process.env.PORT || options.port
		app.use express.logger 'dev'
		app.use express.bodyParser()
		app.use express.methodOverride()
		app.use app.router
		app.use express.static global.home

	app.configure 'development', () ->
		app.use express.errorHandler()

	app.all '*', (req, res, next) ->	
		req.method = req.query._method if req.query._method?
		next()

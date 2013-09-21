
express = 										require('express')
logger = 										require(global.home + '/script/config/express/logger')
Upload = 										require(global.home + '/script/controllers/upload').Upload


module.exports = (app, options, middlevent) ->

	app.configure ->

		# app.set 'trust proxy', true

		app.set 'port', process.env.PORT || options.port.toString()

		app.use express.logger logger

		
		app.use '/upload', (req, res, next) ->

			upload = new Upload(req, res, next)
			upload.emit('upload')


		app.use express.bodyParser()

		app.use express.methodOverride()

		app.use express.cookieParser()

		app.use express.session
			secret:	'ozserver'
			cookie:
				maxAge:	null


		app.use app.router

		app.use express.static global.home + '/public'

		app.configure 'development', () ->
			app.use express.errorHandler()


		app.all '*', (req, res, next) ->
			req.method = req.query._method 		if req.query._method?
			next()

		app.all '*', (req, res, next) ->
			req.session.user = {} 				if !req.session.user?
			next()

		# app.all '*', (req, res, next) ->
		# 	require(global.home + '/script/controllers/auth')(req, res, next).emit('check')




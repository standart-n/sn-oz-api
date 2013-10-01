
express = 										require('express')
session = 										require(global.home + '/script/config/express/session').load
logger = 										require(global.home + '/script/config/express/logger')
Feed = 											require(global.home + '/script/controllers/feed').Feed
Upload = 										require(global.home + '/script/controllers/upload').Upload


module.exports = (app, options, streak) ->

	maxAge = 									365 * 24* 60 * 60 * 1000

	app.configure ->

		app.set 'port', process.env.PORT || options.port.toString()

		app.use express.logger logger
		
		app.use '/feed/post/upload', (req, res, next) ->

			upload = new Upload(req, res, next, options)
			upload.on 'response', (data) ->
				streak.emit 'feed.upload', data
			upload.emit('upload')


		app.use express.bodyParser()

		app.use express.methodOverride()
		
		app.use session

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


express = 		require 'express'
http = 			require 'http'
path = 			require 'path'
# routes = 		require './public/routes'


app = express()

app.configure ->
	app.set 'port', process.env.PORT || 2527
	app.use express.logger 'dev'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use app.router
	app.use express.static __dirname
	app.set app.method, 'PUT'

app.configure 'development', () ->
	app.use express.errorHandler()

app.all '*', (req,res,next) ->	
	req.method = req.query._method if req.query._method?
	next()

app.put '/registration', (req, res) ->
	res.jsonp {a:1}



http.createServer(app).listen app.get('port'), () ->
	console.log "server work at http://localhost:" + app.get('port')


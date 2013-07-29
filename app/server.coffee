
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

app.configure 'development', () ->
	app.use express.errorHandler()


app.get '/', () ->
	console.log 'go!'


http.createServer(app).listen app.get('port'), () ->
	console.log "server work at http://localhost:" + app.get('port')


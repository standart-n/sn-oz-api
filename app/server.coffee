
express = 		require('express')
http = 			require('http')
path = 			require('path')
# routes = 		require './public/routes'

mongoClient = 	require('mongodb').MongoClient

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
	mongoClient.connect 'mongodb://127.0.0.1:27017/mydb', (err, db) ->
		throw err if err
		db.collection('testData').find().toArray (err, doc) ->
			throw err if err
			console.log doc
			res.jsonp {a:1}
			db.close()
			console.log 'end'		


http.createServer(app).listen app.get('port'), () ->
	console.log "server work at http://localhost:" + app.get('port')


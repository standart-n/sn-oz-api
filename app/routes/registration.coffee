
mongoClient = require('mongodb').MongoClient

module.exports = (app, options) ->

	app.put '/registration', (req, res) ->
		mongoClient.connect options.mongodb_connection, (err, db) ->
			throw err if err
			db.collection('testData').find().toArray (err, doc) ->
				throw err if err
				console.log doc
				res.jsonp {a:1}
				db.close()
				console.log 'end'		

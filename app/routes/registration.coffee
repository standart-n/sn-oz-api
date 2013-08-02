
mongoose = 			require('mongoose')
colors = 			require('colors')

module.exports = (app, options) ->

	app.get '/registration', (req, res) ->
		registration = require(global.home + '/script/models/registration/registration')(JSON.parse(req.query.model))

		if registration.model.success is true

			User = mongoose.model 'User', require(global.home + '/script/views/user')
			user = new User(registration.model)
			user.save()

		res.jsonp registration.model

		# if registration.model.success is true
		# 	mongoClient.connect options.mongodb_connection, (err, db) ->
		# 		if db?
		# 			users = db.collection('users')
		# 			users.insert registration.model, (err, docs) ->
		# 				db.close()
		# 				res.jsonp registration.model
		# 			# db.collection('testData').find().toArray (err, doc) ->
		# else
		# 	res.jsonp registration.model	


		# console.log registration.model.blue
		# res.jsonp registration.model


		# mongoClient.connect options.mongodb_connection, (err, db) ->
		# 	throw err if err
		# 	db.collection('testData').find().toArray (err, doc) ->
		# 		throw err if err
		# 		console.log doc
		# 		res.jsonp {a:1}
		# 		db.close()
		# 		console.log 'end'		

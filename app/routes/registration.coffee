
Registration = 		require(global.home + '/script/controllers/registration').Registration

module.exports = (app, options, streak) ->

	app.get '/registration', (req, res) ->

		registration = new Registration(req, res)
		registration.emit('check')



module.exports = (app, options) ->

	app.get '/registration', (req, res) ->

		require(global.home + '/script/controllers/registration')(req, res).emit('check')



module.exports = (app, options) ->

	app.get '/signin', (req, res) ->

		require(global.home + '/script/controllers/signin')(req, res).emit('check')



module.exports = (app, options) ->

	app.get '/signin', (req, res) ->

		require(global.home + '/script/controllers/signin')(req, res).emit('check')


	app.get '/signin/:id/:key', (req, res) ->

		require(global.home + '/script/controllers/signin')(req, res).emit('fetch')

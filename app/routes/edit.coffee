
module.exports = (app, options) ->

	app.put '/edit/password/:id/:key', (req, res) ->

		require(global.home + '/script/controllers/edit')(req, res).emit('password')


module.exports = (app, options) ->

	app.put '/edit/password', (req, res) ->

		require(global.home + '/script/controllers/edit')(req, res).emit('password')

	
	app.put '/edit/personal', (req, res) ->

		require(global.home + '/script/controllers/edit')(req, res).emit('personal')

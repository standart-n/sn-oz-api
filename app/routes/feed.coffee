
module.exports = (app, options) ->

	app.put '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('post')


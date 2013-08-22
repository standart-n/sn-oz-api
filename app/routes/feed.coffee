
module.exports = (app, options) ->


	app.get '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('post')


	app.get '/feed/post/:region', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('get')


	app.put '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('edit')


	app.delete '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('edit')

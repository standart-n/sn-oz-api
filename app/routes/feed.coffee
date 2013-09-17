
module.exports = (app, options) ->




	app.get '/feed/post/:region', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('get')


	app.get '/feed/post/:region/:seria', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('update')



	app.post '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('post')



	app.put '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('edit')


	app.delete '/feed/post/:id', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('destroy')

	

	# old

	app.get '/feed/post', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('post')


	app.put '/feed/post/delete', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('delete')


	app.put '/feed/post/edit', (req, res) ->

		require(global.home + '/script/controllers/feed')(req, res).emit('edit')

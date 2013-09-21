
Feed = 				require(global.home + '/script/controllers/feed').Feed

module.exports = (app, options, middlevent) ->

	app.get '/feed/post/:region', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('get')


	app.get '/feed/post/:region/:seria', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('update')


	app.post '/feed/post', (req, res) ->

		feed = new Feed(req, res)
		feed.on 'response', (data) ->
			middlevent.emit 'feed.post', data
		feed.emit('post')


	app.put '/feed/post', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('edit')


	app.delete '/feed/post/:id', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('destroy')



	# old

	app.get '/feed/post', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('post')


	app.put '/feed/post/delete', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('delete')


	app.put '/feed/post/edit', (req, res) ->

		feed = new Feed(req, res)
		feed.emit('edit')



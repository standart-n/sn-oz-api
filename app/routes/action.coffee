
Actions = 				require(global.home + '/script/controllers/actions').Actions

module.exports = (app, options, streak) ->

	app.get '/action/:aid', (req, res) ->

		actions = new Actions()
		actions.emit('get', req, res)


module.exports = (app, options) ->

	app.get '/remember', (req, res) ->

		require(global.home + '/script/controllers/remember')(req, res).emit('check')


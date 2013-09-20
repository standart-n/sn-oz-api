
Remember = 			require(global.home + '/script/controllers/remember').Remember

module.exports = (app, options) ->

	app.get '/remember', (req, res) ->

		remember = new Remember(req, res)
		remember.emit('check')


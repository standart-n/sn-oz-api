
Signin = 			require(global.home + '/script/controllers/signin').Signin

module.exports = (app, options) ->

	app.get '/signin', (req, res) ->

		signin = new Signin(req, res)
		signin.emit('check')


	app.get '/signin/:id/:key', (req, res) ->

		signin = new Signin(req, res)
		signin.emit('fetch')

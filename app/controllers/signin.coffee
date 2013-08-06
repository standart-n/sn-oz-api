
mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

class Signin extends EventEmitter

	constructor: (@req, @res) ->

		@User = 	mongoose.model('User', require(global.home + '/script/views/user'))
		@mdl = 		require(global.home + '/script/models/signin/signin')(JSON.parse(@req.query.model))

		this.on 'send', () =>
			console.log JSON.stringify(@mdl.model).cyan
			@res.jsonp @mdl.model

		
		this.on 'success', () =>
			user = new @User(@mdl.model)
			user.save()


		this.on 'check', () =>

			if @mdl.valid is true
	
				@User.findOne 
					email: 					@mdl.model.email
					password_hash:			@mdl.model.password_hash
				, (err, exists) =>
					if exists?
						@mdl.success()
						@emit 'send'
					else
						@mdl.fail()
						@emit 'send'

			else
				@emit 'send'




module.exports = (req, res) ->
	new Signin(req, res)

exports.Signin = Signin



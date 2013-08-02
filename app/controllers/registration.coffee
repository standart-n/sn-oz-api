
mongoose = 			require('mongoose')
EventEmitter = 		require('events').EventEmitter

class Registration extends EventEmitter

	constructor: (@req, @res) ->

		@User = 	mongoose.model('User', require(global.home + '/script/views/user'))
		@mdl = 		require(global.home + '/script/models/registration/registration')(JSON.parse(@req.query.model))

		this.on 'send', () =>
			console.log 'mdl', @mdl.model
			@res.jsonp @mdl.model

		
		this.on 'success', () =>
			user = new @User(@mdl.model)
			user.save()


		this.on 'check', () =>
	
			console.log 'check'			

			if @mdl.model.success is true

				console.log 'success'

				@User.findOne email: @mdl.model.email, (err, exists) =>
					if exists?
						console.log 'exists'
						@mdl.emailExists()
						@emit 'send'
					else
						@emit 'success'
						@emit 'send'

			else
				@emit 'send'




module.exports = (req, res) ->
	new Registration(req, res)

exports.Registration = Registration



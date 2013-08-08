
mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

class Registration extends EventEmitter

	constructor: (@req, @res) ->

		@User = 						mongoose.model('User', require(global.home + '/script/views/db/user'))

		this.on 'send', () =>
			console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		
		this.on 'success', () =>
			ObjectId = 					mongoose.Types.ObjectId
			@mdl.model.id = 			new ObjectId
			user = 						new @User(@mdl.model)
			user.save()


		this.on 'check', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/registration/registration')(model)
	
			if @mdl.model.success is true

				@User.findOne 
					email: 				@mdl.model.email
				, (err, exists) =>
					if exists?
						@mdl.emailExists()
						@emit 'send'
					else
						@mdl.genPwd()
						@emit 'success'
						@emit 'send'

			else
				@emit 'send'




module.exports = (req, res) ->
	new Registration(req, res)

exports.Registration = Registration



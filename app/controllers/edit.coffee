
mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

User = 									mongoose.model('User', require(global.home + '/script/views/db/user'))

class Edit extends EventEmitter

	constructor: (@req, @res) ->

		this.on 'send', () =>
			# console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		this.on 'success', () =>
			@mdl.success()
			@emit 'send'

		this.on 'fail', () =>
			@mdl.fail()
			@emit 'send'


		this.on 'password', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/edit/password')(model)
	
			if @mdl.check() is true

				@findUser (user) =>
					user.key =				@mdl.model.key_new
					user.save()
					@emit 'success'
					
			else
				@emit 'send'


		this.on 'personal', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/edit/personal')(model)

			if @mdl.check() is true

				@findUser (user) =>
					user.firstname =		@mdl.model.firstname_new
					user.lastname =			@mdl.model.lastname_new
					user.save()
					@emit 'success'

			else
				@emit 'send'
					


	findUser: (callback) ->

		User.findOne
			id: 						@mdl.model.id
			key:						@mdl.model.key
		, (err, user) =>
			if err or !user?
				@emit 'fail'
			
			else
				callback(user)			if callback?




exports = module.exports = (req, res) ->
	new Edit(req, res)

exports.Edit = Edit



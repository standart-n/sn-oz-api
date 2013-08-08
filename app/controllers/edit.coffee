
mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

class Edit extends EventEmitter

	constructor: (@req, @res) ->

		@User = 						mongoose.model('User', require(global.home + '/script/views/db/user'))

		this.on 'send', () =>
			console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		this.on 'success', () =>
			@mdl.success()

		this.on 'fail', () =>
			@mdl.success()

		this.on 'password', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/edit/password')(model)
	
			if @mdl.check() is true

				@User.findOne 
					id: 				@mdl.model.id
					key:				@mdl.model.key
				, (err, user) =>
					if !err
						user.key =		@mdl.model.key_new
						user.save()
						@emit 'success'
					
					else
						@emit 'fail'
					
					@emit 'send'

			else
				@emit 'send'


		this.on 'personal', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/edit/personal')(model)

			if @mdl.check() is true

				@User.findOne 
					id: 				@mdl.model.id
					key:				@mdl.model.key
				, (err, user) =>
					if !err
						user.firstname =	@mdl.model.firstname_new
						user.lastname =		@mdl.model.lastname_new
						user.save()
						@emit 'success'
					
					else
						@emit 'fail'
					
					@emit 'send'

			else
				@emit 'send'



module.exports = (req, res) ->
	new Edit(req, res)

exports.Edit = Edit




mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

class Signin extends EventEmitter

	constructor: (@req, @res) ->

		@User = 						mongoose.model('User', require(global.home + '/script/views/db/user'))

		this.on 'send', () =>
			console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model


		this.on 'check', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/signin/signin')(model)

			@mdl.check()

			if @mdl.valid is true
	
				@User.findOne 
					email: 				@mdl.model.email
					key:				@mdl.model.key
				, (err, exists) =>
					if exists?.id?
						@mdl.success(exists.id)
					else
						@mdl.fail()

					@emit 'send'

			else
				@emit 'send'


		this.on 'fetch', () =>

			model = if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 	require(global.home + '/script/models/signin/signin')(model)

			@User.findOne 
					id: 				@req.route.params.id
					key:				@req.route.params.key
			, (err, user) =>
				if user?
					@mdl.model = 		user
				@emit 'send'



module.exports = (req, res) ->
	new Signin(req, res)

exports.Signin = Signin



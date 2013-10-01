
_ = 									require('lodash')
mongoose = 								require('mongoose')
colors = 								require('colors')
Token = 								require('token')
EventEmitter = 							require('events').EventEmitter

User = 									mongoose.model('User', require(global.home + '/script/views/db/user'))

class Signin extends EventEmitter

	constructor: (@req, @res) ->

		this.on 'send', () =>
			console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		this.on 'success', () =>
			@mdl.signin()
			@emit 'send'



		this.on 'check', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/signin/signin')(model)

			@mdl.check()

			if @mdl.valid is true
	
				User.findOne 
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

			@mdl = 	require(global.home + '/script/models/signin/signin')()

			User.findOne 
					id: 				if @req.route.params.id? then @req.route.params.id else ''
					key:				if @req.route.params.key? then @req.route.params.key else ''
					disabled:			false
			, (err, user) =>
				if user?
					user.token =		this.generateToken(user).toString()
					user.sessid =		@req.sessionID.toString()
					user.post_dt =		new Date()

					user.save()

					out = 				_.omit user.toJSON(), 'files', 'disabled', 'post_dt', 'reg_dt', '__v', '_id'

					@mdl.model = 		out
					@updateSession 		user.toJSON()

					@emit 'success'

				else
					@mdl.userNotFound()
					@emit 'send'


	updateSession: (user) ->

		@req.session.user.id = 			user.id
		@req.session.user.key = 		user.key
		@req.session.user.email = 		user.email

	
	generateToken: (user) ->
		Token.defaults.secret = 		'ozserver'
		Token.defaults.timeStep = 		24 * 60 * 60
		Token.generate 					"#{@req.session.id}|#{user.id}|#{user.key}"


exports = module.exports = (req, res) ->
	new Signin(req, res)

exports.Signin = Signin



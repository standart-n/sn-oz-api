
mongoose = 								require('mongoose')
colors = 								require('colors')
EventEmitter = 							require('events').EventEmitter

User = 									mongoose.model('User', require(global.home + '/script/views/db/user'))
Post = 									mongoose.model('Post', require(global.home + '/script/views/db/post'))

class Edit extends EventEmitter

	constructor: (@req, @res) ->

		@auth = 						require(global.home + '/script/controllers/auth')(@req, @res)
		@signin = 						require(global.home + '/script/controllers/signin')(@req, @res)

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

				@auth.user (err, user) =>
					if err? or !user?
						@emit 'fail'
					else
						user.key = 		@mdl.model.key_new

						@signin.updateSession(user)

						user.save()

						@emit 'success'
					
			else
				@emit 'send'


		this.on 'personal', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/edit/personal')(model)

			if @mdl.check() is true

				@auth.user (err, user) =>
					if err? or !user?
						@emit 'fail'
					else
						user.firstname =		@mdl.model.firstname_new
						user.lastname =			@mdl.model.lastname_new
						user.save()

						@editPosts()

						@emit 'success'

			else
				@emit 'send'
					
	
	editPosts: () ->

		Post.update
			'author.id':				@mdl.model.id
		,
			'author.firstname':			@mdl.model.firstname_new
			'author.lastname':			@mdl.model.lastname_new
		,
			multi:						true

		.exec()


exports = module.exports = (req, res) ->
	new Edit(req, res)

exports.Edit = Edit



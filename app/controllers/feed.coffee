	
mongoose = 										require('mongoose')
sha1 = 											require('sha1')
EventEmitter = 									require('events').EventEmitter

User = 											mongoose.model('User', require(global.home + '/script/views/db/user'))
Post = 											mongoose.model('Post', require(global.home + '/script/views/db/post'))

class Feed extends EventEmitter

	constructor: (@req, @res) ->

		@auth = 								require(global.home + '/script/controllers/auth')(@req, @res)

		this.on 'send', () =>
			# console.log 						JSON.stringify(@mdl.model)
			@res.jsonp 							@mdl.model


		this.on 'userNotFound', () =>
			@mdl.emit 'userNotFound'
			@emit 'send'

		this.on 'postNotFound', () =>
			@mdl.emit 'postNotFound'
			@emit 'send'

		this.on 'editSuccess', () =>
			@mdl.emit 'success'
			@emit 'send'

		this.on 'deleteSuccess', () =>
			@mdl.emit 'success'
			@emit 'send'


		this.on 'post', () =>

			model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 								require(global.home + '/script/models/feed/post')(model)
		
			if @mdl.check() is true

				@auth.user (err, user) =>
					if err? or !user?
						@emit 'userNotFound'
					else
						post = @post(user)
						post.save()

						@mdl.emit 'success'
						@emit 'send'

			else

				@emit 'send'



		this.on 'get', () =>

			@get (posts) =>
				posts = JSON.parse(JSON.stringify(posts))

				seria  = sha1(JSON.stringify(posts))
				post.seria = seria for post in posts

				@mdl = 							require(global.home + '/script/models/feed/get')(posts)

				@emit 'send'




		this.on 'edit', () =>

			model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 								require(global.home + '/script/models/feed/edit')(model)

			if @mdl.check() is true


				@auth.user (err, user) =>
					if err? or !user?
						@emit 'userNotFound'
					else
						@findPost (post) =>
							if user.id.toString() is post.author.id.toString()
								post.message.text = 	@mdl.model.message.text
								post.save()
								@emit 'editSuccess'

							else 
								@emit 'userNotFound'

			else

				@emit 'send'


		this.on 'update', () =>

			model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 								require(global.home + '/script/models/feed/get')(model)

			if @req.route.params.seria?
				@get (posts) =>

					seria  = sha1(JSON.stringify(posts))

					if seria isnt @req.route.params.seria
						@mdl.needUpdate() 

					@emit 'send'

			else
				@emit 'send'


		this.on 'delete', () =>

			model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 								require(global.home + '/script/models/feed/delete')(model)

			if @mdl.check() is true

				@auth.user (err, user) =>
					if err? or !user?
						@emit 'userNotFound'
					else
						@findPost (post) =>
							if user.id.toString() is post.author.id.toString()
								post.disabled = 	true
								post.save()
								@emit 'deleteSuccess'
							
							else 
								# console.log 'diff', user.id, post.author.id
								@emit 'userNotFound'


			else
				@emit 'send'



	get: (callback) ->

		Post.find
			'region.name':		if @req.route.params.region? then @req.route.params.region else ''
			'disabled':			false
		, null
		,
			limit:				if @req.query?.limit? then @req.query.limit else 100
			sort:							
				post_dt: -1
		, (err, posts) =>
			console.log err if err

			posts ?= []
			
			callback(posts)  	if callback?


	post: (user) ->

		ObjectId = 				mongoose.Types.ObjectId

		post = new Post
			id:					new ObjectId
			
			author:
				id:				user.id
				firstname:		user.firstname
				lastname:		user.lastname
				email:			user.email
				company:		user.company
			
			message:
				text:			@mdl.model.message.text
			
			region:
				caption: 		@mdl.model.region.caption
				name:			@mdl.model.region.name

		post


	findPost: (callback) ->

		Post.findOne
			id:					@mdl.model.id
		, (err, post) =>
			if err or !post?
				@emit 'postNotFound'

			else		
				callback(post)	if callback?



exports = module.exports = (req, res) ->
	new Feed(req, res)

exports.Feed = Feed



	
mongoose = 										require('mongoose')
colors = 										require('colors')
EventEmitter = 									require('events').EventEmitter

User = 											mongoose.model('User', require(global.home + '/script/views/db/user'))
Post = 											mongoose.model('Post', require(global.home + '/script/views/db/post'))

class Feed extends EventEmitter

	constructor: (@req, @res) ->

		this.on 'send', () =>
			console.log 						JSON.stringify(@mdl.model).cyan
			@res.jsonp 							@mdl.model

		this.on 'fail', () =>
			@mdl.fail()
			@emit 'send'


		this.on 'post', () =>

			model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 								require(global.home + '/script/models/feed/post')(model)
		
			if @mdl.check() is true

				@findUser (user) =>

					post = @post(user)
					post.save()

					@mdl.success()

			@emit 'send'



		this.on 'get', () =>

			@get (posts) =>

				@mdl = 							require(global.home + '/script/models/feed/get')(posts)
				@emit 'send'




	get: (callback) ->

		Post.find
			'region.name':		if @req.route.params.region? then @req.route.params.region else ''
		, null
		,
			limit:				if @req.query?.limit? then @req.query.limit else 100
			sort:							
				post_dt: -1
		, (err, posts) =>
			throw err if err

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
				text:			@mdl.model.message
			
			region:
				caption: 		user.region.caption
				name:			user.region.name

		post



	findUser: (callback) ->

		User.findOne
			id: 				@mdl.model.id
			key:				@mdl.model.key
		, (err, user) =>
			if err or !user?
				@emit 'fail'

			else		
				callback(user)	if callback?



exports = module.exports = (req, res) ->
	new Feed(req, res)

exports.Feed = Feed



	
mongoose = 										require('mongoose')
sha1 = 											require('sha1')
formidable = 									require('formidable')
EventEmitter = 									require('events').EventEmitter

User = 											mongoose.model('User', require(global.home + '/script/views/db/user'))
Post = 											mongoose.model('Post', require(global.home + '/script/views/db/post'))

class Feed extends EventEmitter

	constructor: (@req, @res) ->

		@auth = 								require(global.home + '/script/controllers/auth')(@req, @res)

		this.on 'send', (user, post) =>

			@emit 'response', 
				model:			@mdl.model
				user:			if user? 				then user 				else {}
				post:			if post? 				then post 				else {}
				sessid:			if @req.sessionID? 		then @req.sessionID 	else null
				aid:			if @req.body.aid?		then @req.body.aid		else null


			if @req.body.model? or @req.body.sessid?
				@res.set
					'Content-Type': if (req.headers.accept || '').indexOf('application/json') isnt -1 
										'application/json; charset=utf-8' 
									else 
										'text/plain; charset=utf-8'
	
				@res.json 						@mdl.model

			else
				@res.jsonp 						@mdl.model



		this.on 'userNotFound', () =>
			@mdl.emit 'userNotFound'
			@emit 'send'

		this.on 'postNotFound', () =>
			@mdl.emit 'postNotFound'
			@emit 'send'


		this.on 'postSuccess', (user, post) =>
			@mdl.emit 'success'
			@emit 'send', user, post

		this.on 'editSuccess', (user, post) =>
			@mdl.emit 'success'
			@emit 'send', user, post

		this.on 'deleteSuccess', (user, post) =>
			@mdl.emit 'success'
			@emit 'send', user, post


		this.on 'post', () =>

			# model = 							if @req.query?.model? then JSON.parse(@req.query.model) else {}
			if @req.query?.model?
				model = 						JSON.parse(@req.query.model)

			if @req.body?.model?
				model = 						JSON.parse(@req.body.model)

			model ?= {}		

			@mdl = 								require(global.home + '/script/models/feed/post')(model)
		
			if @mdl.check() is true

				@auth.user (err, user) =>
					if err? or !user?
						@emit 'userNotFound'
					else
						post = @post(user)
						post.save()

						@emit 'postSuccess', user.toJSON(), post.toJSON()

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

			if @req.query?.model?
				model = 						JSON.parse(@req.query.model)

			if @req.body?.model?
				model = 						JSON.parse(@req.body.model)

			model ?= {}		
			
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
								@emit 'editSuccess', user.toJSON(), post.toJSON()

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

			@mdl = 								require(global.home + '/script/models/feed/delete')({})

			@auth.user (err, user) =>
				if err? or !user?
					@emit 'userNotFound'
				else
					@findPost (post) =>
						if user.id.toString() is post.author.id.toString()
							post.disabled = 	true
							post.save()
							@emit 'deleteSuccess', user.toJSON(), post.toJSON()
						
						else 
							# console.log 'diff', user.id, post.author.id
							@emit 'userNotFound'


		this.on 'upload', () =>

			form = new formidable.IncomingForm()
			form.parse @req, (err, fields, files) =>
				console.log 'err',		err
				console.log 'fields',	fields
				console.log 'files', 	files

				# @res.json


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
				text:			if @mdl.model.message?.text? 		then @mdl.model.message.text 		else ''

			attachments:
				files:			if @mdl.model.attachments?.files? 	then @mdl.model.attachments.files 	else []
			
			region:
				caption: 		if @mdl.model.region?.caption? 		then @mdl.model.region.caption		else ''
				name:			if @mdl.model.region?.name?			then @mdl.model.region.name 		else ''

		post


	findPost: (callback) ->

		Post.findOne
			id:					if @req.route.params.id? then @req.route.params.id else @mdl.model.id
		, (err, post) =>
			if err or !post?
				@emit 'postNotFound'

			else		
				callback(post)	if callback?



exports = module.exports = (req, res) ->
	new Feed(req, res)

exports.Feed = Feed



	
_ = 											require('underscore')
mongoose = 										require('mongoose')
EventEmitter = 									require('events').EventEmitter
upload = 										require('jquery-file-upload-middleware')

User = 											mongoose.model('User', require(global.home + '/script/views/db/user'))


class Upload extends EventEmitter

	constructor: (@req, @res, @next) ->

		this.on 'send', () =>
			@res.json 							@mdl.model

		this.on 'userNotFound', () =>
			@mdl.emit 'userNotFound'
			@emit 'send'


		this.on 'upload', () =>

			@mdl = 								require(global.home + '/script/models/upload/file')()
		
			@findUser (user) =>

				upload.once 'end', (fileInfo) =>
					if @req.method is 'POST'
						# console.log @req.session
						console.log fileInfo

				upload.fileHandler(
					# maxFileSize: 				10000000 		# 10mb
					maxFileSize: 				1000000 		# 1mb
					uploadDir: 					"#{global.home}/public/uploads/#{user.email}"
					uploadUrl: 					"/uploads/#{user.email}"
				)(@req, @res, @next)



	findUser: (callback) ->

		User.findOne
			id: 				if @req.query.id? 	then @req.query.id 		else ''
			key:				if @req.query.key? 	then @req.query.key 	else ''
			disabled:			false
		, (err, user) =>
			if err or !user?
				@emit 'userNotFound'

			else		
				callback(user)	if callback?



exports = module.exports = (req, res, next) ->
	new Upload(req, res, next)

exports.Upload = Upload



	
_ = 											require('lodash')
fs = 											require('fs')
gm = 											require('gm')
mongoose = 										require('mongoose')
EventEmitter = 									require('events').EventEmitter
upload = 										require('jquery-file-upload-middleware')

User = 											mongoose.model('User', require(global.home + '/script/views/db/user'))


class Upload extends EventEmitter

	constructor: (@req, @res, @next, @options) ->

		this.on 'send', () =>
			@emit 'response', 
				file:							@mdl.model
				aid:							if @req.query.aid?		then @req.query.aid		else null

			@res.json 							@mdl.model

		this.on 'userNotFound', () =>
			@mdl.emit 'userNotFound'
			@emit 'send'


		this.on 'upload', () =>

			@mdl = 								require(global.home + '/script/models/upload/file')()
		
			@findUser (user) =>

				upload.once 'end', (fileInfo) =>

					ObjectId = 					mongoose.Types.ObjectId
					fileInfo.id = 				new ObjectId

					if @options.uploads_url.toString().match(/^http/)
						fileInfo.url = 			"#{@options.uploads_url}/#{user.email}/#{fileInfo.name}"

					fileInfo.delete_url = 		null
					fileInfo.delete_type = 		null

					if @req.method is 'POST'

						user.files.push			fileInfo
						user.save()

						if fileInfo.type.match /^image/

							gm("#{@options.uploads_directory}/#{user.email}/#{fileInfo.name}")
								.resize(200)
								.stream (err, stdout, stderr) =>
									console.log err if err
									writeStream = fs.createWriteStream("#{@options.uploads_directory}/#{user.email}/resize.png")
									stdout.pipe(writeStream)
								# .write("resize.png", (err) -> console.log err if err )

						@emit 'response', 
							file:				fileInfo
							user:				user
							aid:				if @req.query.aid?		then @req.query.aid		else null

				upload.fileHandler(
					# maxFileSize: 				10000000 		# 10mb
					maxFileSize: 				@options.max_user_file_size_mb * 1024 * 1024
					uploadDir: 					"#{@options.uploads_directory}/#{user.email}"
					uploadUrl: 					"#{@options.uploads_url}/#{user.email}"
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



exports = module.exports = (req, res, next, options) ->
	new Upload(req, res, next)

exports.Upload = Upload



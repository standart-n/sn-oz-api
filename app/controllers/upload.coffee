	
_ = 											require('lodash')
gm = 											require('gm')
async = 										require('async')
mongoose = 										require('mongoose')
mkpath = 										require('mkpath')
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

				uploadDir = 					"#{@options.uploads_directory}/#{user.email}"
				uploadUrl = 					"#{@options.uploads_url}/#{user.email}"

				mkpath.sync						"#{uploadDir}"
				mkpath.sync						"#{uploadDir}/thumbnail"
				mkpath.sync						"#{uploadDir}/preview"

				upload.once 'end', (fileInfo) =>

					fileDir = 					"#{uploadDir}/#{fileInfo.name}"
					fileUrl = 					"#{uploadUrl}/#{fileInfo.name}"

					ObjectId = 					mongoose.Types.ObjectId
					fileInfo.id = 				new ObjectId

					if @options.uploads_url.toString().match(/^http/)
						fileInfo.url = 			"#{fileUrl}"

					fileInfo.delete_url = 		null
					fileInfo.delete_type = 		null

					if @req.method is 'POST'

					
						if fileInfo.type.match /^image/

							thumbDir = 				"#{uploadDir}/thumbnail/#{fileInfo.name}"
							thumbUrl = 				"#{uploadUrl}/thumbnail/#{fileInfo.name}"

							previewDir = 			"#{uploadDir}/preview/#{fileInfo.name}"
							previewUrl = 			"#{uploadUrl}/preview/#{fileInfo.name}"

							fileInfo.thumbnail = 	"#{thumbUrl}"
							fileInfo.preview = 		"#{previewUrl}"


						user.files.push				fileInfo
						user.save()

						@emit 'response', 
							file:					fileInfo
							user:					user
							aid:					if @req.query.aid?		then @req.query.aid		else null


						if fileInfo.type.match /^image/

							gm("#{fileDir}").orientation (err, orientation) =>

								gm("#{fileDir}").size (err, resolution) =>
									
									previewRes = 	@crop(resolution.width, resolution.height, 200, 200, orientation)
								
									gm("#{fileDir}")
										.autoOrient()
										.resize(previewRes.width, previewRes.height)
										.crop(200, 200, previewRes.x, previewRes.y)
										.write "#{previewDir}", (err) ->
											throw err if err

									gm("#{fileDir}")
										.autoOrient()
										.thumb 640, 480, "#{thumbDir}", 75, (err) ->
											throw err if err


				upload.fileHandler(
					# maxFileSize: 				10000000 		# 10mb
					maxFileSize: 				@options.max_user_file_size_mb * 1024 * 1024
					uploadDir: 					"#{uploadDir}"
					uploadUrl: 					"#{uploadUrl}"
				)(@req, @res, @next)


	crop: (w, h, need_w, need_h, orientation = 'TopLeft') ->

		result = {}

		if orientation.match /^Left/ or orientation.match /^Right/
			a = w
			w = h
			h = a

		if Number(w) > 0 then k_w = Number(need_w) / Number(w) else k_w = 0
		if Number(h) > 0 then k_h = Number(need_h) / Number(h) else k_h = 0

		if k_w >= k_h then k = k_w else k = k_h

		result.width = 		Math.ceil(k * w)
		result.height = 	Math.ceil(k * h)

		result.x = 			Math.ceil((result.width - 	Number(need_w)) 	/ 2)
		result.y = 			Math.ceil((result.height - 	Number(need_h)) 	/ 2)

		result



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



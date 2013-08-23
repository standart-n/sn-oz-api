

validate = 								require('validate')
EventEmitter = 							require('events').EventEmitter

Schema = 								require(global.home + '/script/views/validate/post')

class Post extends EventEmitter


	constructor: (@model = {}) ->

		this.on 'success', () ->
			@model.success = 			true
			@model.notice = 			'Сообщение успешно добавлено'

		this.on 'userNotFound', () ->
			@model.success = 			false
			@model.notice = 			'Не удалось добавить комментарий'


	check: () ->

		@model.success = 				false
		@model.message.text = 			@model.message.text.toString().trim()

		@model.notice = 				validate(Schema, @model)

		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString().replace('Error: ','')
		else 
			@model.success = 			true

		@model.success


exports = module.exports = (model = {}) ->
	new Post(model)

exports.Post = Post

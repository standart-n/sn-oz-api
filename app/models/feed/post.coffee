

validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/post')

class Post

	valid: 								false

	constructor: (@model = {}) ->


	check: () ->

		@model.post_result = 			false
		@model.message = 				@model.message.trim()

		@model.notice = 				validate(Schema, @model)

		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString()
		else 
			@model.post_result = 		true

		@model.post_result


	success: () ->
		@model.notice = 				'Сообщение успешно добавлено'
		@model.post_result = 			true

	fail: () ->
		@model.post_result = 			false
		@model.notice = 				'Не удалось добавить комментарий'

	userNotFound: () ->
		@model.post_result = 			false
		@model.notice = 				'Пользователь не найден'
		

module.exports = (model = {}) ->
	new Post(model)

exports.Post = Post
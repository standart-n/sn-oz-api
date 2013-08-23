

validate = 								require('validate')
EventEmitter = 							require('events').EventEmitter

Schema = 								require(global.home + '/script/views/validate/post')

class Edit extends EventEmitter


	constructor: (@model = {}) ->

		this.on 'success', () =>
			@model.success = 			true
			@model.notice = 			'Сообщение успешно изменено'

		this.on 'userNotFound', () =>
			@model.success = 			false
			@model.notice = 			'Не удалось найти информацию об авторе данного поста'

		this.on 'postNotFound', () =>
			@model.success = 			false
			@model.notice = 			'Не удалось найти пост, который требуется изменить'


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
	new Edit(model)

exports.Edit = Edit

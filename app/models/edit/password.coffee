
sha1 = 									require('sha1')
validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/security')

class Edit

	constructor: (@model = {}) ->


	check: () ->

		@model.password_change = 		false
		@model.password_new = 			@model.password_new.trim()
		@model.password_repeat = 		@model.password_repeat.trim()

		@model.notice = 				validate(Schema, @model)

		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString()
		else 
			if @model.password_new is @model.password_repeat
				@model.password_change = 	true
				@model.key_new = 			sha1(@model.password_new)
			else
				@model.notice = 		'Пароли не совпадают'

		@model.password_change


	success: () ->
		@model.key = 					@model.key_new
		@model.key_new = 				null
		@model.password_new = 			null
		@model.password_repeat = 		null
		@model.notice = 				'Пароль успешно изменен'
		@model.password_change = 		true

	fail: () ->
		@model.password_change = 		false
		@model.notice = 				'Не удалось изменить пароль'
		

module.exports = (model = {}) ->
	new Edit(model)

exports.Edit = Edit


sha1 = 									require('sha1')

class Edit

	valid: 								false

	constructor: (@model = {}) ->


	check: () ->
		if @model.id? isnt '' and @model.key? isnt ''
			if @model.password_new? isnt '' and @model.password_repeat? isnt ''
				@valid = 				true

		if @valid isnt true
			@model.notice = 			'отсутствуют данные'

		if @valid is true

			if @model.password_new is @model.password_repeat
				
				@model.key_new = 		sha1(@model.password_new)

			else
				@valid = 				false
				@model.notice = 		'пароли не совпадают'

		@valid

	success: () ->
		@model.key = 					@model.key_new
		@model.key_new = 				null
		@model.password_new = 			null
		@model.password_repeat = 		null
		@model.notice = 				'пароль успешно изменен'
		@model.password_change = 		true

	fail: () ->
		@model.password_change = 		false
		@model.notice = 				'не удалось записать новые даннные'
		

module.exports = (model = {}) ->
	new Edit(model)

exports.Edit = Edit


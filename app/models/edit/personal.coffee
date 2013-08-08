

validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/personal')

class Personal

	valid: 								false

	constructor: (@model = {}) ->


	check: () ->

		@model.personal_change = 		false
		@model.firstname_new = 			@model.firstname_new.trim()
		@model.lastname_new = 			@model.lastname_new.trim()

		@model.notice = 				validate(Schema, @model)

		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString()
		else 
			@model.personal_change = 	true

		@model.personal_change


	success: () ->
		@model.firstname = 				@model.firstname_new
		@model.lastname = 				@model.lastname_new
		@model.firstname_new = 			null
		@model.lastname_new = 			null
		@model.notice = 				'Данные успешно изменены'
		@model.personal_change = 		true

	fail: () ->
		@model.personal_change = 		false
		@model.notice = 				'Не удалось записать новые даннные'
		

module.exports = (model = {}) ->
	new Personal(model)

exports.Personal = Personal

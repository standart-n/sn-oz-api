

validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/personal')

class Personal

	constructor: (@model = {}) ->

		@valid = 						false


	check: () ->

		@model.success = 				false
		@model.firstname_new = 			@model.firstname_new.trim()
		@model.lastname_new = 			@model.lastname_new.trim()

		@model.notice = 				validate(Schema, @model)

		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString().replace('Error: ','')
		else 
			@model.success = 			true

		@model.success


	success: () ->
		@model.success = 				true
		@model.firstname = 				@model.firstname_new
		@model.lastname = 				@model.lastname_new
		@model.firstname_new = 			null
		@model.lastname_new = 			null
		@model.notice = 				'Данные успешно изменены'

	fail: () ->
		@model.success = 				false
		@model.notice = 				'Не удалось записать новые даннные'
		

exports = module.exports = (model = {}) ->
	new Personal(model)

exports.Personal = Personal



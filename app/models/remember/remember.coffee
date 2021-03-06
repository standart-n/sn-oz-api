

randomString =							require('random-string')
sha1 = 									require('sha1')
validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/remember')

class Remember

	constructor: (@model) ->

		@check()
		@validate()

	check: () ->
		@model.email = 					@model.email.toString().trim().toLowerCase()

	validate: () ->
		@model.notice = 				validate(Schema, @model)
		if Array.isArray(@model.notice)
			@model.notice = 			@model.notice[0].toString().replace('Error: ','')
			@model.success = 			false
		else 
			@model.success = 			true

	genPwd: () ->
		@model.password = 				randomString(length: 5).toLowerCase()
		@model.key = 					sha1(@model.password).toString()

	success: () ->
		@model.key = 					null
		@model.password = 				null


	emailExists: () ->
		@model.success = 				false
		@model.notice = 					'Данный email-адрес не найден'



exports = module.exports = (model = {}) ->
	new Remember(model)

exports.Remember = Remember


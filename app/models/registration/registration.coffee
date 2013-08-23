

randomString =							require('random-string')
sha1 = 									require('sha1')
validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/registration')

class Registration

	constructor: (@model) ->

		@check()
		@validate()

	check: () ->
		@model.firstname = 				@model.firstname.toString().trim()
		@model.lastname = 				@model.lastname.toString().trim()
		@model.email = 					@model.email.toString().trim().toLowerCase()
		@model.company = 				@model.company.toString().trim()

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

	emailExists: () ->
		@model.success = 				false
		@model.notice = 					'Данный email-адрес уже используется'



exports = module.exports = (model = {}) ->
	new Registration(model)

exports.Registration = Registration


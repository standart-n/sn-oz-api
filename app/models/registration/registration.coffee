

randomString =							require('random-string')
sha1 = 									require('sha1')
validate = 								require('validate')

Schema = 								require(global.home + '/script/views/validate/registration')

class Registration

	constructor: (@model) ->

		@check()
		@validate()

	check: () ->
		@model.firstname = 				@model.firstname.trim()
		@model.lastname = 				@model.lastname.trim()
		@model.email = 					@model.email.trim().toLowerCase()
		@model.company = 				@model.company.trim()

	validate: () ->
		@model.valid = 					validate(Schema, @model)
		if Array.isArray(@model.valid)
			@model.valid = 				@model.valid[0].toString()
			@model.success = 			false
		else 
			@model.success = 			true

	genPwd: () ->
		@model.password = 				randomString(length: 5).toLowerCase()
		@model.key = 					sha1(@model.password).toString()

	emailExists: () ->
		@model.success = 				false
		@model.valid = 					'Error: данный email-адрес уже используется'



exports = module.exports = (model = {}) ->
	new Registration(model)

exports.Registration = Registration




randomString =							require('random-string')
sha1 = 									require('sha1')

class Registration

	constructor: (@model) ->
		@model.valid = {}
		@model.err = {}

		@check()
		@validate()
		@err()

		if @model.err.field? and @model.err.description?
			@model.success = false 
		else 
			@model.success = true

	check: () ->
		@model.firstname = 				@model.firstname.trim()
		@model.lastname = 				@model.lastname.trim()
		@model.email = 					@model.email.trim().toLowerCase()
		@model.company = 				@model.company.trim()

	err: () ->
		if @model.valid? and typeof @model.valid is 'object'
			for key, value of @model.valid
				if value isnt true
					@model.err.field = 			key
					@model.err.description = 	value
					break

	validate: () ->
		@model.valid.firstname = 		require(global.home + '/script/models/validate/firstname')(@model.firstname)
		@model.valid.lastname = 		require(global.home + '/script/models/validate/lastname')(@model.lastname)
		@model.valid.email = 			require(global.home + '/script/models/validate/email')(@model.email)
		@model.valid.company = 			require(global.home + '/script/models/validate/company')(@model.company)


	genPwd: () ->
		@model.password = 				randomString(length: 5).toLowerCase()
		@model.key = 					sha1(@model.password).toString()

	emailExists: () ->
		@model.success = 				false
		@model.err.field = 				'email'
		@model.err.description = 		'указан адрес, который уже используется'



module.exports = (model = {}) ->
	new Registration(model)

exports.Registration = Registration



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
		@model.lastname = 				@model.lastname.trim()
		@model.firstname = 				@model.firstname.trim()
		@model.email = 					@model.email.trim()
		@model.company = 				@model.company.trim()

	err: () ->
		if @model.valid? and typeof @model.valid is 'object'
			for key, value of @model.valid
				if value isnt true
					@model.err.field = 			key
					@model.err.description = 	value
					break

	validate: () ->
		@model.valid.lastname = 		require(global.home + '/script/models/validate/lastname')(@model.lastname)
		@model.valid.firstname = 		require(global.home + '/script/models/validate/firstname')(@model.firstname)
		@model.valid.email = 			require(global.home + '/script/models/validate/email')(@model.email)
		@model.valid.company = 			require(global.home + '/script/models/validate/company')(@model.company)







module.exports = (model = {}) ->
	new Registration(model)

exports.Registration = Registration

class Registration

	constructor: (@model) ->
		@validate()

	validate: () ->
		@model.valid = {}
		@model.valid.firstname = 		require(global.home + '/script/validate/firstname')(@model.firstname)
		@model.valid.lastname = 		require(global.home + '/script/validate/lastname')(@model.lastname)
		@model.valid.email = 			require(global.home + '/script/validate/email')(@model.email)
		@model.valid.company = 			require(global.home + '/script/validate/company')(@model.company)
		






module.exports = (model = {}) ->
	new Registration(model)

exports.Registration = Registration
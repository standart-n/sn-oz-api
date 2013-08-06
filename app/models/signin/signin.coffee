
sha1 = 									require('sha1')

class Signin

	valid: 								false

	constructor: (@model) ->

		if @model.email? and @model.password?
			@valid = 					true

		if @valid is true
			@model.email = 				@model.email.trim()
			@model.password = 			@model.password.trim()

			@model.success = 			false
			@model.password_hash = 		sha1(@model.password)

		else
			@model.err = 				'отсутствуют данные'

	success: () ->
		@model.notice = 				'авторизация прошла успешно'
		@model.success = 				true

	fail: () ->
		@model.notice = 				'неверно введен логин или пароль'

module.exports = (model = {}) ->
	new Signin(model)

exports.Signin = Signin


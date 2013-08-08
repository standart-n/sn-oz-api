
sha1 = 									require('sha1')

class Signin

	valid: 								false

	constructor: (@model = {}) ->


	check: () ->
		if @model.email? and @model.password?
			@valid = 					true

		if @valid is true
			@model.email = 				@model.email.trim()
			@model.password = 			@model.password.trim()

			@model.success = 			false
			@model.key = 				sha1(@model.password)

		else
			@model.err = 				'Отсутствуют данные'


	success: (id) ->
		@model.id = 					id
		@model.notice = 				'Авторизация прошла успешно'
		@model.success = 				true
		@model.password = 				null

	fail: () ->
		@model.key = 					null
		@model.password = 				null
		@model.notice = 				'Вы неверно ввели логин или пароль'

		

module.exports = (model = {}) ->
	new Signin(model)

exports.Signin = Signin


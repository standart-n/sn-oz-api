
module.exports = 

	id:
		type: 'string'
		len: 24
		required: true
		message: 'Пользователь не определен'

	key:
		type: 'string'
		len: 40
		required: true
		message: 'Пользователь не определен'

	password_new:
		type: 'string'
		required: true
		minLen: 3
		maxLen: 20
		message: 'Значение нового пароля некорректно'
		custom: (s) ->
			s.match(/^([\w]+)$/gi)


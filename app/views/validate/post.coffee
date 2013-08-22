
module.exports = 

	author:

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

	message:

		text:
			type: 'string'
			required: true
			minLen: 3
			maxLen: 255
			message: 'Сообщение некорректно'


	region:

		caption:
			type: 'string'
			required: true
			minLen: 3
			maxLen: 100
			message: 'Неопределен регион пользователя'

		name:
			type: 'string'
			required: true
			minLen: 3
			maxLen: 100
			message: 'Неопределен регион пользователя'
			custom: (s) ->
				s.match(/^([a-z]+)$/gi)


module.exports = 


	message:

		text:
			type: 'string'
			required: true
			minLen: 3
			maxLen: 100000
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

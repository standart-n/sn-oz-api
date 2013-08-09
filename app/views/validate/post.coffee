
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

	message:
		type: 'string'
		required: true
		minLen: 3
		maxLen: 255
		message: 'Сообщение некорректно'

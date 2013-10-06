
module.exports = 

	id:
		type: 'string'
		len: 24
		required: true
		message: 'Пользователь не определен'

	firstname_new:			
		type: 'string'
		required: true
		minLen: 2
		maxLen: 20
		message: 'Неверно заполнено поле Имя'
		custom: (s) ->
			s.match(/^([\D]+)$/gi)

	lastname_new:
		type: 'string'
		required: true
		minLen: 2
		maxLen: 20
		message: 'Неверно заполнено поле Фамилия'
		custom: (s) ->
			s.match(/^([\D]+)$/gi)

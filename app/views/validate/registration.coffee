
module.exports = 

	firstname:			
		type: 'string'
		required: true
		minLen: 3
		maxLen: 20
		message: 'Неверно заполнено поле Имя'
		custom: (s) ->
			s.match(/^([\D]+)$/gi)

	lastname:
		type: 'string'
		required: true
		minLen: 3
		maxLen: 20
		message: 'Неверно заполнено поле Фамилия'
		custom: (s) ->
			s.match(/^([\D]+)$/gi)

	email:
		type: 'email'
		required: true
		message: 'Неверно заполнено поле Email'

	company:			
		type: 'string'
		required: true
		minLen: 3
		maxLen: 20
		message: 'Неверно заполнено поле Компания'

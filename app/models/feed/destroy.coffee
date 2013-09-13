

validate = 								require('validate')
EventEmitter = 							require('events').EventEmitter

Schema = 								require(global.home + '/script/views/validate/post')

class Destroy extends EventEmitter


	constructor: (@model = {}) ->

		this.on 'success', () =>
			@model.success = 			true
			@model.notice = 			'Сообщение успешно удалено'

		this.on 'userNotFound', () =>
			@model.success = 			false
			@model.notice = 			'Не удалось найти информацию об авторе данного поста'

		this.on 'postNotFound', () =>
			@model.success = 			false
			@model.notice = 			'Не удалось найти пост, который требуется изменить'
		

exports = module.exports = (model = {}) ->
	new Destroy(model)

exports.Destroy = Destroy


EventEmitter = 							require('events').EventEmitter

class File extends EventEmitter


	constructor: (@model = {}) ->

		this.on 'userNotFound', () =>
			@model.error = 				'User Not Found'
		

exports = module.exports = (model = {}) ->
	new File(model)

exports.File = File

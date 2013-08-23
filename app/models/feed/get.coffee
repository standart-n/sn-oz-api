

validate = 								require('validate')

class Get


	constructor: (@model = {}) ->
		this.update = 					false


	needUpdate: () ->
		@model.update = 				true


exports = module.exports = (model = {}) ->
	new Get(model)

exports.Get = Get

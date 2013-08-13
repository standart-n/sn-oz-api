

validate = 								require('validate')

class Get


	constructor: (@model = {}) ->

		valid = 						false


exports = module.exports = (model = {}) ->
	new Get(model)

exports.Get = Get

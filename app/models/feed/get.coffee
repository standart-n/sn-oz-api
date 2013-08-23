

validate = 								require('validate')

class Get


	constructor: (@model = {}) ->



exports = module.exports = (model = {}) ->
	new Get(model)

exports.Get = Get

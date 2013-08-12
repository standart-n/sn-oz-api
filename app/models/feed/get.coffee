

validate = 								require('validate')

class Get

	valid: 								false

	constructor: (@model = {}) ->



module.exports = (model = {}) ->
	new Get(model)

exports.Get = Get

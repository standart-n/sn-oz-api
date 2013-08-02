
module.exports = (value) ->

	valid = false	

	if value? and typeof value is 'string'
		if value.length > 3
			if value.length < 30
				valid = true
			else
				valid = 'слишком длинное значение'	
		else
			valid = 'слишком короткое значение'	
	else
		valid = 'некорректное значение'
			
	valid

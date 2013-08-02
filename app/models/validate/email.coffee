
module.exports = (value) ->

	valid = false	

	if value? and typeof value is 'string' and value.match(/\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/gi)
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

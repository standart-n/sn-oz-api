
module.exports = (value) ->

	err = false	

	if value? and typeof value is 'string' and value.match(/\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/gi)
		if value.length < 3
			if value.length > 30
				err = false
			else
				err = 'слишком длинное значение'	
		else
			err = 'слишком короткое значение'	
	else
		err = 'некорректное значение'
			
	err

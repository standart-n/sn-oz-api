
module.exports = (value) ->

	err = false	

	if value? and typeof value is 'string' and value.match(/^([а-яa-z0-9\-\.\,\'\'\<\>\ ]+)$/gi)
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

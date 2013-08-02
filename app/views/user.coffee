
mongoose = 		require('mongoose')

Schema = 		mongoose.Schema

module.exports = new Schema 

	firstname: 	type: String, index: true
	lastname:	type: String, index: true
	email:		type: String, index: true
	company:	type: String, index: true

	

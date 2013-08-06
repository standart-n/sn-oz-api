
Schema = 				require('mongoose').Schema

module.exports = 		new Schema 

	firstname:			type: String, index: true
	lastname:			type: String, index: true
	email:				type: String, index: true
	company:			type: String, index: true
	key:				type: String, index: true

	region:
		caption:		type: String
		name:			type: String, index: true


	reg_dt:				type: Date, default: Date.now
	

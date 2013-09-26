
Schema = 				require('mongoose').Schema

module.exports = 		new Schema 

	aid:				type: String, index: true

	data:				type: Object

	post_dt:			type: Date, default: Date.now


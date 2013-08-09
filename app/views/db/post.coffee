
Schema = 				require('mongoose').Schema

module.exports = 		new Schema 

	id:					type: Schema.Types.ObjectId

	author:
		id:				type: Schema.Types.ObjectId
		firstname:		type: String
		lastname:		type: String
		email:			type: String
		company:		type: String

	message:
		text:			type: String

	region:
		caption:		type: String
		name:			type: String, index: true


	post_dt:			type: Date, default: Date.now
,
	_id:				false
	

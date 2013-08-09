
Schema = 				require('mongoose').Schema

module.exports = 		new Schema 

	id:					type: Schema.Types.ObjectId
	email:				type: String, lowercase: true, trim: true, index: true
	key:				type: String, index: true
,
	_id:				false
	

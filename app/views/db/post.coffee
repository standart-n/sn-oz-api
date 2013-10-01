
Schema = 						require('mongoose').Schema

module.exports = 				new Schema 

	id:							type: Schema.Types.ObjectId

	author:
		id:						type: Schema.Types.ObjectId
		firstname:				type: String
		lastname:				type: String
		email:					type: String
		company:				type: String

	message:
		text:					type: String

	attachments:

		files: [
			id:					type: Schema.Types.ObjectId
			name:				type: String
			originalName: 		type: String
			url: 				type: String
			size: 				type: Number
			group:				type: String
			type: 				type: String, default: 'file'
			disabled: 			type: Boolean, default: false
		]


	region:
		caption:				type: String
		name:					type: String, index: true

	post_dt:					type: Date, default: Date.now

	disabled:					type: Boolean, default: false

,
	_id:						false
	


mongoose = 								require('mongoose')
colors = 								require('colors')
jade = 									require('jade')
EventEmitter = 							require('events').EventEmitter

mailer = 								require(global.home + '/script/controllers/mailer')

User = 									mongoose.model('User', require(global.home + '/script/views/db/user'))

class Registration extends EventEmitter

	constructor: (@req, @res) ->

		this.on 'send', () =>
			# console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		
		this.on 'success', () =>
			ObjectId = 					mongoose.Types.ObjectId
			@mdl.model.id = 			new ObjectId
			user = 						new User(@mdl.model)
			user.save()
			@mail()


		this.on 'check', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/registration/registration')(model)


			if @mdl.model.success is true

				User.findOne 
					email: 				@mdl.model.email
				, (err, exists) =>
					if exists?
						@mdl.emailExists()
						@emit 'send'
					else
						@mdl.genPwd()
						@emit 'success'
						@emit 'send'

			else
				@emit 'send'


	mail: () ->
		html = jade.renderFile global.home + '/view/mail/registration.jade',
			email:		@mdl.model.email
			password:	@mdl.model.password

		mailer.send @mdl.model.email, 'Общий Заказ - поздравляем с успешной регистрацией!', html


exports = module.exports = (req, res) ->
	new Registration(req, res)

exports.Registration = Registration



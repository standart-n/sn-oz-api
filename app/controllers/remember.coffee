
mongoose = 								require('mongoose')
colors = 								require('colors')
jade = 									require('jade')
EventEmitter = 							require('events').EventEmitter

mailer = 								require(global.home + '/script/controllers/mailer')

User = 									mongoose.model('User', require(global.home + '/script/views/db/user'))

class Remember extends EventEmitter

	constructor: (@req, @res) ->

		this.on 'send', () =>
			# console.log 				JSON.stringify(@mdl.model).cyan
			@res.jsonp 					@mdl.model

		
		this.on 'success', () =>
			@mail()
			@mdl.success()
			@emit 'send'


		this.on 'check', () =>

			model = 					if @req.query?.model? then JSON.parse(@req.query.model) else {}
			@mdl = 						require(global.home + '/script/models/remember/remember')(model)
	
			if @mdl.model.success is true

				User.findOne 
					email: 				@mdl.model.email
				, (err, user) =>
					if !user?
						@mdl.emailExists()
						@emit 'send'
					else
						@mdl.genPwd()
						console.log user.key
						user.key = @mdl.model.key
						console.log user.key
						user.save()
						@emit 'success'

			else
				@emit 'send'


	mail: () ->
		html = jade.renderFile global.home + '/view/mail/remember.jade',
			password:	@mdl.model.password

		mailer.send @mdl.model.email, 'Общий Заказ - смена пароля', html


exports = module.exports = (req, res) ->
	new Remember(req, res)

exports.Remember = Remember



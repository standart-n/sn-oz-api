

nodemailer = 												require('nodemailer')
Storage = 													require(global.home + '/script/controllers/storage').Storage


class Mailer

	constructor: () ->

		throw 'global.mail is not exists' 					if !global.mail?

		@mail = 											new Storage(global.mail)

		@smtpTransport = nodemailer.createTransport 'SMTP',
			host: @mail.get('host')
			auth:
				user: @mail.get('user')
				pass: @mail.get('password')

	send: (email, subject, html) ->

		if email? and subject? and html?

			@smtpTransport.sendMail
				from: 		@mail.get('email')
				to: 		email
				subject: 	subject
				html: 		html
			, (err, response) ->
				if err
					console.log err
				else
					console.log "Message sent: " + response.message



exports = module.exports = new Mailer()

exports.Mailer = Mailer
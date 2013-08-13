

nodemailer = 												require('nodemailer')
Storage = 													require(global.home + '/script/controllers/storage').Storage


class Mail

	constructor: () ->

		@conf = 											new Storage(global.mail)

		@smtpTransport = nodemailer.createTransport 'SMTP',
			host: @conf.get('host')
			auth:
				user: @conf.get('user')
				pass: @conf.get('password')

# smtpTransport.sendMail
# 	from: "oz <oz@standart-n.ru>"
# 	to: "aleks nick <aleksnick@list.ru>"
# 	subject: "Hello, Aleks "
# 	text: "standart-n "
# , (err, response) ->
# 	console.log 'email'
# 	if err
# 		console.log err
# 	else
# 		console.log "Message sent: " + response.message



exports = module.exports = new Mail()

exports.Mail = Mail

colors = 				require('colors')
bytes = 				require('bytes')
moment = 				require('moment')

module.exports = (token, req, res) ->

	status = res.statusCode
	len = parseInt(res.getHeader('Content-Length'), 10)
	color = 32;

	if status >= 500 
		color = 31
	else
		if status >= 400
			color = 33
		else 
			if status >= 300 
				color = 36

	len = if isNaN(len) then '' else len = bytes(len)

	tm = (new Date() - req._startTime).toString() + 'ms'

	dt = new Date().toString()

	"#{moment().format('HH:mm:ss.SSS').blue} #{moment().format('L').grey} \x1b[#{color}m#{req.method} \x1b[#{color}m#{res.statusCode} #{tm.cyan} #{len.yellow} #{req.originalUrl.grey}"

	# "\x1b[90m#{req.method} #{req.originalUrl} \x1b[#{color}m #{res.statusCode} \x1b[90m#{(new Date - req._startTime)}ms+ #{len} \x1b[0m"

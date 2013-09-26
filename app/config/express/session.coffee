
express = 						require('express')
connectSession = 				require('connect-session')
session = 						connectSession.session

Memory = 						require(global.home + '/script/controllers/memory')(express)


body = (options = {}) ->
	paramName = if options.param? then options.param else 'sessid'
	(req) ->
		req.body[paramName]

query = (options = {}) ->
	paramName = if options.param? then options.param else 'sessid'
	(req) ->
		req.query[paramName]


loaders = [
	query()
	body()
]

options = 
	store: new Memory()


module.exports.create = 		session loaders, options

module.exports.load = 			session loaders, options

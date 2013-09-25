
connectSession = 				require('connect-session')
session = 						connectSession.session
header = 						connectSession.header
param = 						connectSession.param

MemoryStore = 					require(global.home + '/node_modules/connect-session/lib/session/memory')

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
	store = new MemoryStore


module.exports.create = 		session loaders, options

module.exports.load = 			session loaders, options

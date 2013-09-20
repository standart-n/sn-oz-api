
sockjs = 				require('sockjs')

module.exports = (server, middlevent) ->

	sockets = sockjs.createServer
		sockjs_url: global.home + '/lib/sockjs/sockjs.js'
	

	sockets.on 'connection', (socket) ->

		client = 
			id:		if socket._session?.session_id? then socket._session.session_id else null
			region: {}


		socket.on 'data', (s) ->
			data = JSON.parse(s)

			if data?.message?
				switch data.message
					when 'connect'
						client.region = data.region if data.region?


		middlevent.on 'feed.update', (model) ->
			if socket._session?.readyState? and  model.region?.name? and client.region?.name?
				if socket._session.readyState is 1 and model.region.name is client.region.name
					console.log client.id, 'feed.update'
					socket.write JSON.stringify
						message:	'feed.update'


	sockets.installHandlers server,
		prefix:'/sockets'

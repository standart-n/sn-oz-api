
sockjs = 				require('sockjs')
colors = 				require('colors')

module.exports = (server, streak) ->

	sockets = sockjs.createServer
		log: (severity, line) ->
			console.log line.grey

	sockets.on 'connection', (socket) ->

		client = 
			id:				if socket._session?.session_id? then socket._session.session_id else null
			token:			null
			sessid:			null
			region: 		{}
			user_id: 		0


		socket.on 'data', (s) ->
			data = JSON.parse(s)

			if data?.message?
				switch data.message
					when 'connect'
						client.region = 	data.region 		if data.region?
						client.user_id = 	data.user_id 		if data.user_id?
						client.token = 		data.token 			if data.token?
						client.sessid = 	data.sessid 		if data.sessid?




		streak.on 'feed.post', (data) ->
			if this.isSocketReady(socket)
				if this.isRegionRight(client, data)
					if this.isPostedSuccess(data)
						socket.write JSON.stringify
							message:	'feed.update'



		streak.on 'feed.edit', (data) ->
			if this.isSocketReady(socket)
				if this.isRegionRight(client, data)
					if this.isPostedSuccess(data)
						socket.write JSON.stringify
							message:	'feed.update'


		streak.on 'feed.delete', (data) ->
			if this.isSocketReady(socket)
				if this.isRegionRight(client, data)
					socket.write JSON.stringify
						message:	'feed.update'


	sockets.installHandlers server,
		prefix:'/sockets'






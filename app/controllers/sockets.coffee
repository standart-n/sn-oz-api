
sockjs = 				require('sockjs')

module.exports = (server, middlevent) ->

	sockets = sockjs.createServer()
	# sockjs_url: global.home + '/lib/sockjs/sockjs.js'
	

	sockets.on 'connection', (socket) ->

		client = 
			id:				if socket._session?.session_id? then socket._session.session_id else null
			token:			null
			region: 		{}
			user_id: 		0


		socket.on 'data', (s) ->
			data = JSON.parse(s)

			if data?.message?
				switch data.message
					when 'connect'
						client.region = 	data.region 	if data.region?
						client.user_id = 	data.user_id 	if data.user_id?
						client.token = 		data.token 		if data.token?




		middlevent.on 'feed.post', (data) ->
			if this.isSocketReady(socket)
				if this.isRegionRight(client, data)

					if this.isClientIsAuthorOfPost(client, data)
						socket.write JSON.stringify
							message:	'feed.post'
							success:	if data?.model?.success? 		then data.model.success 	else null
							notice:		if data?.model?.notice? 		then data.model.notice 		else null
					else
						if this.isPostedSuccess(data)
							socket.write JSON.stringify
								message:	'feed.update'



	sockets.installHandlers server,
		prefix:'/sockets'






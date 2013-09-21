	
EventEmitter = 									require('events').EventEmitter

class Middlevent extends EventEmitter

	constructor: () ->


	isSocketReady: (socket) ->
		if socket?._session?.readyState?
			if socket._session.readyState is 1
				return true
		return false

	isRegionRight: (client, data) ->
		if client?.region?.name? and data?.model?.region?.name?
			if client.region.name is data.model.region.name
				return true
		return false

	isClientIsAuthorOfPost: (client, data) ->
		if client?.user_id? and data?.user?.id?
			if client.user_id.toString() is data.user.id.toString()
				if client.token? and data?.token?
					if client.token.toString() is data.token.toString()
						return true
					else
						return false
				return true
		return false

	isPostedSuccess: (data) ->
		if data?.model?.success?
			if data.model.success is true
				return true
		return false


exports = module.exports = () ->
	new Middlevent()

exports.Middlevent = Middlevent



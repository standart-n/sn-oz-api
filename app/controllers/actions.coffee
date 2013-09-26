
EventEmitter = 		require('events').EventEmitter
mongoose = 			require('mongoose')

Action = 			mongoose.model('Action', require(global.home + '/script/views/db/action'))

class Actions extends EventEmitter

	constructor: (@options = {}) ->

		this.on 'get', (req, res) =>

			if req.route.params.aid?
				this.get req.route.params.aid.toString(), (err, data) ->
					if err
						res.jsonp err
					else
						res.jsonp data
			else
				res.jsonp {}
						


	set: (aid, data, fn) ->

		Action.findOne
			aid:	aid
		, (err, action) =>
			if err 
				fn and fn(err) if fn
			else
				if action?
					action.post_dt = 	new Date()
					action.data = 		data
					
					action.save () ->
						fn and fn(null, action.toJSON()) if fn
				
				else
					action = new Action
						aid:	aid
						data:	data
					
					action.save () ->
						fn and fn(null, action.toJSON()) if fn



	get: (aid, fn) ->

		Action.findOne
			aid:	aid
		, (err, action) ->
			if err 
				fn(err) if fn
			else
				if action?
					json = action.toJSON()
					if json.data?
						res = json.data
					else
						res = {}

					action.remove () ->
						fn and fn(null, res) if fn

				else 
					fn and fn(null, null) if fn



	destroy: (aid, fn) ->

		Action.findOne
			aid:	aid
		, (err, action) ->
			if err 
				fn and fn(err) if fn
			else
				action.remove () ->
					fn() if fn


exports = module.exports = (options = {}) ->

	new Actions(options)


exports.Actions = Actions



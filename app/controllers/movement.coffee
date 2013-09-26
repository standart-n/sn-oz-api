
actions = 				require(global.home + '/script/controllers/actions')()

module.exports = (streak) ->


	streak.on 'feed.post', (data) ->
		if data.aid?
			actions.set data.aid,
				message:	'feed.post'
				success:	if data?.model?.success? 		then data.model.success 	else null
				notice:		if data?.model?.notice? 		then data.model.notice 		else null


	streak.on 'feed.edit', (data) ->
		if data.aid?
			actions.set data.aid,
				message:	'feed.edit'
				success:	if data?.model?.success? 		then data.model.success 	else null
				notice:		if data?.model?.notice? 		then data.model.notice 		else null



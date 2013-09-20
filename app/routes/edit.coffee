
Edit = 				require(global.home + '/script/controllers/edit').Edit

module.exports = (app, options) ->

	app.put '/edit/password', (req, res) ->

		edit = new Edit(req,res)
		edit.emit('password')

	
	app.put '/edit/personal', (req, res) ->

		edit = new Edit(req,res)
		edit.emit('personal')


# require
program = 				require('commander')											# commander.js
path = 					require('path')													# path module
fs = 					require('fs')													# fs module

# path to root dir
if !fs.existsSync("/usr/lib/ozserver")
	fs.mkdirSync		"/usr/lib/ozserver"
if !fs.existsSync("/usr/lib/ozserver/default")
	fs.mkdirSync		"/usr/lib/ozserver/default"
global.home = 			__dirname
global.store = 			"/usr/lib/ozserver/default/mail.json"

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

mail = 					require(global.home + '/script/controllers/storage')			# storage.js

# init store
mail.store(global.mail)

# init program
program.version(pkg.version)

# add storage fn to program
require(global.home + '/script/config/program/mail')(program, mail)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

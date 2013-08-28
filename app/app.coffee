
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
global.store = 			"/usr/lib/ozserver/default/store.json"
global.mail = 			"/usr/lib/ozserver/default/mail.json"

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

server = 				require(global.home + '/script/controllers/server')				# server.js

mailer = 				require(global.home + '/script/controllers/mailer')

# init program
program.version(pkg.version)

# add server fn to program
require(global.home + '/script/config/program/server')(program, server)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

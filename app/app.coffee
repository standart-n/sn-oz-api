
# require
program = 				require('commander')											# commander.js
path = 					require('path')													# path module

# path to root dir
global.home = 			__dirname
global.store = 			__dirname + '/store.json'
global.mail = 			__dirname + '/mail.json'

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

server = 				require(global.home + '/script/controllers/server')				# server.js


# init program
program.version(pkg.version)

# add server fn to program
require(global.home + '/script/config/program/server')(program, server)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

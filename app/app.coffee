
# path to root dir
global.home = 			__dirname
global.store = 			__dirname + '/store.json'

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

program = 				require('commander')											# commander.js
path = 					require('path')													# path module
storage = 				require(global.home + '/script/controllers/storage')			# storage.js
server = 				require(global.home + '/script/controllers/server')				# server.js

# init store
storage.store(global.store)

# init program
program.version(pkg.version)

# add server fn to program
require(global.home + '/script/program/server')(program, server)

# add storage fn to program
require(global.home + '/script/program/storage')(program, storage)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

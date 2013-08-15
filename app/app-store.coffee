
# require
program = 				require('commander')											# commander.js
path = 					require('path')													# path module

# path to root dir
global.home = 			__dirname
global.store = 			__dirname + '/conf/store.json'

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

store = 				require(global.home + '/script/controllers/storage')			# storage.js

# init store
store.store(global.store)

# init program
program.version(pkg.version)

# add storage fn to program
require(global.home + '/script/config/program/store')(program, store)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

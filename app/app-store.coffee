
# require
program = 				require('commander')											# commander.js
path = 					require('path')													# path module
mkpath = 				require('mkpath')												# mkpath module

# path to root dir
global.home = 			__dirname

mkpath.sync				"/usr/lib/ozserver/default"

global.store = 			"/usr/lib/ozserver/default/store.json"

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

# init program
program.version(pkg.version)

# add storage fn to program
require(global.home + '/script/config/program/store')(program)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'


program = 				require('commander')
path = 					require('path')
mkpath = 				require('mkpath')

global.home = 			__dirname

mkpath.sync				"/usr/lib/ozserver/default"

global.mail = 			"/usr/lib/ozserver/default/mail.json"

# default output
global.command = 		'help'

# package.json
pkg = 					require(global.home + '/package.json')

# init program
program.version(pkg.version)

# add storage fn to program
require(global.home + '/script/config/program/mail')(program)

# parse argcv
program.parse(process.argv)

# default output
program.help() if global.command is 'help'

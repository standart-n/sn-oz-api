
# require
program = 				require('commander')											# commander.js
path = 					require('path')													# path module

# path to root dir
global.home = 			__dirname
global.mail = 			__dirname + '/conf/mail.json'

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

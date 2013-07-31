var Settings, path, settings;

global.home = __dirname;

path = require('path');

Settings = require(global.home + '/script/settings');

settings = new Settings(global.home + '/settings.json');

settings.quest('test1');

process.exit(0);

console.log(settings.set('test2', 'russia'));

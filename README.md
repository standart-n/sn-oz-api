## API для Новостей Общего Заказа

> Внутренняя разработка компании [Стандарт-Н](http://standart-n.ru/)

#### Запуск сервера в терминале

```bash
 
  Usage: ozserver [options] [command]

  Commands:

    run                    run server

  Options:

    -h, --help     output usage information
    -V, --version  output the version number

  Examples:

    $ ozserver run

```

#### Настройка сервера

```bash

  Usage: ozserver-conf [options] [command]

  Commands:

    set <key> <value>      set settings
    get <key>              get settings
    remove <key>           remove settings
    import <data>          import data into settings
    export                 export data from settings

  Options:

    -h, --help     output usage information
    -V, --version  output the version number

  Examples:

    $ ozserver-conf set port 2244
    $ ozserver-conf get mongodb_connection

```

#### Установка спомощью npm 

```bash
	npm install -g ozserver	
```

#### Установка с github

```bash
	# скачиваем
	git clone https://github.com/standart-n/ozserver
	# переходим в папку проекта
	cd ./ozserver
	# устанавливаем необоходимые пакеты
	make install
	# собираем проект 
	make
	# запускаем
	node ozserver
```

#### Запуск сервера как процесс

```bash
	# установка forever
	npm install forever -g
	# запуск
	forever start -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log ozserver run
```

#### Остановка сервера

```bash
	# просмотр процессов
	forever list
	# остановка
	forever stop ozserver
```

#### License

The MIT License (MIT)

Copyright (c) 2013 standart-n

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




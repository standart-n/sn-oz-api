## API сервер для Новостей Общего Заказа

> Внутренняя разработка компании [Стандарт-Н](http://standart-n.ru/)

#### Требования

```
  * GCC 4.2 or newer
  * Python 2.6 or 2.7
  * GNU Make 3.81 or newer
  * libexecinfo (FreeBSD and OpenBSD only)
  * Node.js 0.10.10 or newer
  * NPM.js 1.2.25 or newer
  * MongoDB 2.4.5 or newer
```

#### Запуск сервера в терминале

```
  $ ozserver run
```


```
  
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

**Параметры:**

 - **port** -  порт, на котором будет работать сервер
 - **mongodb_connection** - строка подключения к базе данных mongodb

```
  $ ozserver-store
```


```
  Usage: ozserver-store [options] [command]

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

    $ ozserver-store set port 2244
    $ ozserver-store get mongodb_connection
```

#### Настройка почты

**Параметры:**

 - **email** -  адрес с которого будет отправляться почта
 - **host** -  ip почтового сервера сервер
 - **user** - пользователь
 - **password** - пароль

```
  $ ozserver-mail
```


```
  Usage: ozserver-mail [options] [command]

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

    $ ozserver-mail set email office@standart-n.ru
    $ ozserver-mail get host
```


#### Установка сервера спомощью npm 

```
	npm install -g ozserver	
```

#### Установка из исходного кода

```bash
	# скачиваем
	$ git clone https://github.com/standart-n/ozserver
	# переходим в папку проекта
	$ cd ./ozserver
	# устанавливаем необоходимые пакеты
	$ make install
	# собираем проект 
	$ make
	# запускаем
	$ node ozserver
```

#### Запуск сервера спомощью forever

```
	# установка forever
	$ npm install forever -g
	# запуск
	$ forever start -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log ozserver run
```

#### Остановка сервера

```
	# просмотр процессов
	$ forever list
	# остановка
	$ forever stop ozserver
```

### API


#### Авторизация пользователя

**Авторизация по e-mail и паролю**

 - GET /signin
   - email
   - password

**Авторизация по ключу**

 - GET /signin/:id/:key


#### Регистрация пользователя
  
**Простая регистрация**  

 - GET /registration
   - model
     - firstname
     - lastname
     - email
     - company


#### Редактирование информации о пользователе

**Личные данные**

 - PUT /edit/personal
   - model
     - id
     - key
     - firstname\_new
     - lastname\_new


**Смена пароля**

 - PUT /edit/password
   - model
     - id
     - key
     - password\_new
     - password\_repeat


#### Функция вспомнить пароль

**Смена пароля**

 - GET /remember
   - model
     - email


#### Лента новостей

**Получение новостей**

 - GET /feed/post/:region
   - [limit]

**Добавление новости**

 - PUT /feed/post
   - model
     - id (user)
     - key (user)
     - message



### License

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




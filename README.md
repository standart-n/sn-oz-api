## API сервер для Новостей Общего Заказа

> Внутренняя разработка компании [Стандарт-Н](http://standart-n.ru/)

#### Требования к серверу

```
  * GCC 4.2 or newer
  * Python 2.6 or 2.7
  * GNU Make 3.81 or newer
  * libexecinfo (FreeBSD and OpenBSD only)
  * Node.js 0.10.10 or newer
  * NPM.js 1.2.25 or newer
  * MongoDB 2.4.5 or newer
```


#### Как привязать сервер к доменному имени в nginx


```
  server {
    # пор, который слушает nginx
    listen 8080;
    # доменные имена
    server_name api.oz.st-n.ru www.api.oz.st-n.ru;
    # путь к логам
    access_log /var/log/nginx/st-n.log;

    location / {
      # 127.0.0.1 - здесь мб адрес любой машины в сети
      # 2424 - порт который слушает запущенный нами сервер
      proxy_pass http://127.0.0.1:2424/;
      proxy_redirect off;
      proxy_set_header Host $host;
      proxy_set_header X-real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }

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
  # ключ -g указывает что пакет установится глобально
  # если на машине будет запущен только один сервер
  # то для установки достаточно ввести следующую команду:
  $ npm install -g ozserver	
  # затем можно запустить сервер
  $ ozserver run


  # если необходимо запустить несколько серверов на одной машине,
  # то следует устанавливать пакеты локально:
  # создаем каталог, в котором будет располагаться пакет
  $ mkdir -p /var/www/oz/api/server_1/
  # переходим в даннный каталог
  $ cd /var/www/oz/api/server_1
  # устанавливаем пакет
  $ npm install ozserver
  # переходим в ныжный каталог
  $ cd node_modules/ozserver
  # запускаем
  $ node ozserver run
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
  $ node ozserver run
```

#### Запуск сервера спомощью forever

```
  # установка forever
  $ npm install forever -g
  # запуск
  # -o - путь к обычным логам
  # -е - путь к логам с ошибками
  # если сервер был установлен глобально, то: 
  $ forever start -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log ozserver run
  # если сервер был установлен локально, то:
  # переходим в папку с локальным пакетом
  $ cd /var/www/oz/api/server_1
  # указываем forever какой файл требуется запустить
  $ forever start -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log ./ozserver run

```

#### Остановка сервера

```
  # просмотр процессов
  $ forever list
  # остановка
  $ forever stop ozserver
```

### Структура запросов к серверу


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
     - region


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

 - GET /feed/post
   - model
     - author (user)
     - message
     - region



### Структура базы данных


Коллекция пользователей, **users**


```
  id:           type: Schema.Types.ObjectId
  firstname:    type: String, trim: true, index: true
  lastname:     type: String, trim: true, index: true
  email:        type: String, lowercase: true, trim: true, index: true
  company:      type: String, trim: true, index: true
  key:          type: String, index: true

  region:
    caption:    type: String
    name:       type: String, index: true


  signin:       type: Boolean, default: true

  reg_dt:       type: Date, default: Date.now

```


Коллекция новостей, **posts**

```
  id:             type: Schema.Types.ObjectId

  author:
    id:           type: Schema.Types.ObjectId
    firstname:    type: String
    lastname:     type: String
    email:        type: String
    company:      type: String

  message:
    text:         type: String

  region:
    caption:      type: String
    name:         type: String, index: true


  post_dt:        type: Date, default: Date.now

```


### Валидация данных


Регистрация пользователя

```
  firstname:      
    type: 'string'
    required: true
    minLen: 3
    maxLen: 20
    message: 'Неверно заполнено поле Имя'
    custom: (s) ->
      s.match(/^([\D]+)$/gi)

  lastname:
    type: 'string'
    required: true
    minLen: 3
    maxLen: 20
    message: 'Неверно заполнено поле Фамилия'
    custom: (s) ->
      s.match(/^([\D]+)$/gi)

  email:
    type: 'email'
    required: true
    message: 'Неверно заполнено поле Email'

  company:      
    type: 'string'
    required: true
    minLen: 3
    maxLen: 20
    message: 'Неверно заполнено поле Компания'

```


Отправка сообщения в общую ленту

```
  author:

    id:
      type: 'string'
      len: 24
      required: true
      message: 'Пользователь не определен'

    key:
      type: 'string'
      len: 40
      required: true
      message: 'Пользователь не определен'

  message:

    text:
      type: 'string'
      required: true
      minLen: 3
      maxLen: 255
      message: 'Сообщение некорректно'

```


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




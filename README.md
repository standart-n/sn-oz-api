## API сервер для Новостей Общего Заказа

> Внутренняя разработка компании [Стандарт-Н](http://standart-n.ru/)

Данная разработка представляет из себя серверную часть системы Новости Общего Заказа и 
предназначена для обработки запросов от клиентской части. Сервер работает с базой данных [MongoDB](http://www.mongodb.org/).

  - Пример клиентской части: [http://oz.st-n.ru/publish/](http://oz.st-n.ru/publish/)
  - Исходный код клиентской части: [https://github.com/standart-n/sn-oz-client](https://github.com/standart-n/sn-oz-client)
  - Сервер построен на [node.js](http://nodejs.org/) фреймворке [express](http://expressjs.com/)
  - Работа с базой данных ведется спомощью [mongoose](http://mongoosejs.com/)
  - Обмен данными между клиентской частью и сервером происходит спомощью [JSONP](http://ru.wikipedia.org/wiki/JSONP) формата


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


#### Запуск сервера в терминале

```
ozserver run
```

```
  Usage: ozserver [options] [command]

  Commands:

    run                    run server

  Options:

    -h, --help                 output usage information
    -V, --version              output the version number
    -c, --connection <string>  connection string to mongodb
    -p, --port <port>          port for server
    -P, --profile <name>       profile for settings in /usr/lib/ozserver

  Examples:

    $ ozserver run
```

#### Настройка сервера

**Параметры:**

 - **port** -  порт, на котором будет работать сервер
 - **mongodb_connection** - строка подключения к базе данных mongodb

```
ozserver-store
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

    -h, --help            output usage information
    -V, --version         output the version number
    -P, --profile <name>  profile for settings in /usr/lib/ozserver

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
ozserver-mail
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

    -h, --help            output usage information
    -V, --version         output the version number
    -P, --profile <name>  profile for settings in /usr/lib/ozserver

  Examples:

    $ ozserver-mail set email office@standart-n.ru
    $ ozserver-mail get host
```


#### Установка сервера спомощью npm 

##### Если на машине будет запущен только один сервер, то пакет можно установить глобально
 
устанавливаем

```
npm install --global ozserver   
```
затем можно запустить сервер

```
ozserver run
```


##### Eсли необходимо запустить несколько серверов на одной машине

создаем каталог, в который установим сервер

```
mkdir -p /var/www/oz/api/server_1/
```
переходим в даннный каталог

```
cd /var/www/oz/api/server_1
```

устанавливаем пакет

```
npm install ozserver
```
переходим в нужный каталог

```
cd node_modules/ozserver
```
запускаем

```
node ozserver run
```

#### Установка из исходного кода

скачиваем

```
git clone https://github.com/standart-n/sn-oz-api
```
переходим в папку проекта

```
cd ./sn-oz-api
```
собираем проект 

```
make
```
запускаем

```
node ozserver run
```


### Создание сервиса

для этого должен быть установлен ```forever```

```
npm install -g forever
```

создадим в каталоге ```/etc/init.d``` файл ```ozserver``` и выставим ему права на исполнение

```
cd /etc/init.d/
touch ozserver
chmod 755 ./ozserver
```

далее откроем файл на редактирование спомощью ```nano``` и вставим в него следующий код

```
#!/bin/sh
#
### BEGIN INIT INFO
# Provides:          ozserver
# Required-Start:    $all
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: oz server api
# Description:       oz server
#                    api
#
### END INIT INFO

export USER=root
export PWD=/root
export HOME=/root
export PATH=$PATH:/usr/local/bin
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export NODE_ENV=production

case "$1" in
'start')
exec forever start -a -l /var/log/ozserver.forever.log -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log --sourceDir=/usr/local/lib/node_modules/ozserver/ ozserver run > /var/log/ozserver.init.log
;;
'stop')
exec forever stop /usr/local/lib/node_modules/ozserver/ozserver > /var/log/ozserver.init.log
;;
'restart')
exec forever -a -l /var/log/ozserver.forever.log -o /var/log/ozserver.out.log -e /var/log/ozserver.err.log restart /usr/local/lib/node_modules/ozserver/ozserver > /var/log/ozserver.init.log
;;
'status')
exec forever list
;;
*)
echo "Usage: $0 { start | stop | restart | status }"
exit 1
;;
esac
exit 0
```

в результате мы получим сервис ```/etc/init.d/ozserver``` 

```
/etc/init.d/ozserver start
/etc/init.d/ozserver status
/etc/init.d/ozserver stop
```

##### После этого можно добавить сервис в автозагрузку

добавить в автозагрузку

```
update-rc.d ozserver defaults
```

убрать запуск сервера из автозагрузки

```
update-rc.d ozserver remove
```


##### Как настроить logrotate

создаем файл конфигурации

```
touch /etc/logrotate.d/ozserver
```

открываем его спомощью ```nano``` и записываем туда:

```
/var/log/ozserver*.log {
    daily
    rotate 5
    create 644 root adm
    missingok
    notifempty
    compress
    delaycompress
    postrotate
      /etc/init.d/ozserver stop
      /etc/init.d/ozserver start
    endscript
}
```

применяем конфигурацию

```
logrotate /etc/logrotate.conf
```

далее можно протестировать

```
logrotate -f /etc/logrotate.conf
```



#### Как привязать сервер к доменному имени в nginx


```
  server {
    # порт, который слушает nginx
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


### Структура запросов к серверу


#### Авторизация пользователя

**Авторизация по e-mail и паролю**

 - **GET** /signin
   - email
   - password

**Авторизация по ключу**

 - **GET** /signin/:id/:key


#### Регистрация пользователя
  
**Простая регистрация**  

 - **GET** /registration
   - model
     - firstname
     - lastname
     - email
     - company
     - region


#### Редактирование информации о пользователе

**Личные данные**

 - **PUT** /edit/personal
   - model
     - id
     - firstname\_new
     - lastname\_new


**Смена пароля**

 - **PUT** /edit/password
   - model
     - id
     - password\_new


#### Функция вспомнить пароль

**Восстановление пароля**

 - **GET** /remember
   - model
     - email


#### Лента новостей

**Получение новостей**

 - **GET** /feed/post/:region
   - [limit]

**Проверка актуальности ленты новостей**

 - **GET** /feed/post/:region/:seria
   - [limit]

**Добавление новости**

 - **POST** /feed/post
   - model
     - message
     - region

**Редактирование своей новости**

 - **PUT** /feed/post
   - model
     - id
     - message

**Удаление своей новости**

 - **DELETE** /feed/post/:id



### Журнал изменений

##### 16 сен 2013г. v0.1.4

  - Переход на сессии.

  - Упростил API.


##### 04 сен 2013г. v0.1.4

  - Загрузка файлов на сервер:

   - ограничение на 10мб

   - проверка на авторизацию

##### 02 сен 2013г.

  - Исправил ошибку с форматом даты в логах.

  - Упростил установку с GitHub.

##### 28 авг 2013г. v0.1.3

  - Добавил вывод даты и времени запроса в логах.

##### 28 авг 2013г. v0.1.2

  - Сделал возможность создавать профили настроек через ```--profile```.

##### 28 авг 2013г. v0.1.1

  - Добавил инструкцию по созданию сервиса для данного сервера. 
   Это позволяет запускать сервев в качестве демона, а также можно добавить этот 
   сервис в автозагрузку.

  - Возможность запускать сервер с командами ```--port``` и ```--connection```.

  - Перенес настройки в ```/usr/lib/ozserver```, чтобы они не затирались при обновлении сервера.

  - Увеличил лимит сообщения с ```255``` до ```100000```.


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




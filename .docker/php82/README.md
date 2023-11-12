# dofroscra-php-8.2-fpm

https://github.com/johanvanhelden/dofroscra

## Available tags
- `latest`

## Building and publishing

Ensure you are logged in locally to hub.docker.com using `docker login` and have access to the hub repository.
(note: your username is used, not your email address).

Ensure the latest version of is present by running:
```bash
docker pull mlocati/php-extension-installer
```

Run the build process:
```bash
docker build ./ --tag johanvanhelden/dofroscra-php-8.2-fpm:TAG
```

Publish the build:
```bash
docker push johanvanhelden/dofroscra-php-8.2-fpm:TAG
```

Replace `TAG` with the tag you are working on.

## Development

If you want to test a new feature, create a new tag for it. This way, it can not introduce issues in the production image if something is not working properly.

Once it works, delete the custom tag and introduce it into `latest`

## Testing the image locally

```
$ docker-compose up --build
$ docker exec -it dofroscra-php-8.2-fpm-testing bash
```

## Enabled PHP modules
```
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
hash
iconv
imagick
imap
intl
json
libxml
mbstring
mysqli
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
random
readline
redis
Reflection
session
SimpleXML
soap
sodium
SPL
sqlite3
ssh2
standard
tokenizer
xml
xmlreader
xmlrpc
xmlwriter
xsl
zip
zlib
```

#!/bin/bash

## ABSOLUTE path to the spawn-fcgi binary
SPAWNFCGI="/usr/bin/spawn-fcgi" 

## ABSOLUTE path to the PHP binary
FCGIPROGRAM="/usr/bin/php-cgi" 

## ABSOLUTE path to UNIX socket
FCGISOCKET="/var/run/php.socket" 

## uncomment the PHPRC line, if you want to have an extra php.ini for this user
## store your custom php.ini in /var/www/fastcgi/fred/php.ini
## with an custom php.ini you can improve your security
## just set the open_basedir to the users webfolder
## Example: (add this line in you custom php.ini)
## open_basedir = /var/www/vhosts/fred/html
##
#PHPRC="/var/www/fastcgi/fred/" 

## number of PHP childs to spawn in addition to the default. Minimum of 2.
## Actual childs = PHP_FCGI_CHILDREN + 1
PHP_FCGI_CHILDREN=5

## number of request server by a single php-process until is will be restarted
PHP_FCGI_MAX_REQUESTS=1000

## IP adresses where PHP should access server connections from
FCGI_WEB_SERVER_ADDRS="127.0.0.1" 

# allowed environment variables sperated by spaces
ALLOWED_ENV="PATH USER" 

## if this script is run as root switch to the following user
USERID=user
GROUPID=group

################## no config below this line

if test x$PHP_FCGI_CHILDREN = x; then
  PHP_FCGI_CHILDREN=5
fi

export PHP_FCGI_MAX_REQUESTS
export FCGI_WEB_SERVER_ADDRS
export PHPRC

ALLOWED_ENV="$ALLOWED_ENV PHP_FCGI_MAX_REQUESTS FCGI_WEB_SERVER_ADDRS PHPRC" 

# copy the allowed environment variables
E=

for i in $ALLOWED_ENV; do
  E="$E $i=$(eval echo "\$$i")" 
done

# clean environment and set up a new one
env - $E $SPAWNFCGI -s $FCGISOCKET -f $FCGIPROGRAM -u $USERID -g $GROUPID -C $PHP_FCGI_CHILDREN

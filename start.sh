#!/bin/bash

# ============================================================================
# Special thanks for guys in this thread:
# https://stackoverflow.com/questions/6174220/parse-url-in-shell-script
# ============================================================================

# parsing postgres connection string
# ============================================================================
# extract the protocol
proto="`echo $DATABASE_URL | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
# remove the protocol
url=`echo $DATABASE_URL | sed -e s,$proto,,g`

# extract the user and password (if any)
userpass="`echo $url | grep @ | cut -d@ -f1`"
pass=`echo $userpass | grep : | cut -d: -f2`
if [ -n "$pass" ]; then
    user=`echo $userpass | grep : | cut -d: -f1`
else
    user=$userpass
fi

# extract the host -- updated
hostport=`echo $url | sed -e s,$userpass@,,g | cut -d/ -f1`
port=`echo $hostport | grep : | cut -d: -f2`
if [ -n "$port" ]; then
    host=`echo $hostport | grep : | cut -d: -f1`
else
    host=$hostport
fi

# extract the path (if any)
path="`echo $url | grep / | cut -d/ -f2-`"

# parsing ended
# ============================================================================

export FUSIONAUTH_APP_HTTP_PORT=$PORT
export FUSIONAUTH_APP_URL="http://0.0.0.0:"$PORT
export DATABASE_URL="jdbc:postgresql://$host:$port/$path"
export DATABASE_USERNAME="$user"
export DATABASE_PASSWORD="$pass"

#echo "Database URL: $DATABASE_URL"
#echo "Database Username: $DATABASE_USERNAME"
#echo "Database Password: $DATABASE_PASSWORD"

# start fusionauth-app
/usr/local/fusionauth/fusionauth-app/apache-tomcat/bin/catalina.sh run
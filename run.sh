#!/bin/bash
SCRIPT_PATH=$(dirname `which $0`)
source $SCRIPT_PATH/env.sh

echo $TAG
echo $NAME
docker run \
	--name $NAME \
	-p 10080:80 \
	--link openldap:ldap \
	-v /site/etc/$NAME:/ext/etc \
	-v /site/log/$NAME:/ext/log \
	-i \
	-t $TAG \
	/bin/bash

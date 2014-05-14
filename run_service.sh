#!/bin/bash
SCRIPT_PATH=$(dirname `which $0`)
source $SCRIPT_PATH/env.sh

echo docker run \
	--name $NAME \
	--link ldap:ldap \
	-v /site/etc/$NAME:/ext/etc \
	-v /site/log/$NAME:/ext/log \
	-t $TAG
docker run \
	--name $NAME \
	--link ldap:ldap \
	-v /site/etc/$NAME:/ext/etc \
	-v /site/log/$NAME:/ext/log \
	-t $TAG

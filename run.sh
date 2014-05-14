#!/bin/bash
TAG=`git config --get remote.origin.url | sed 's/.*\/\(.*\/.*\)/\1/'`
NAME=`echo $TAG | sed 's/.*\/.*-\(.?*\)/\1/'`

echo $TAG
echo $NAME
docker run \
	--name $NAME \
	--link ldap:ldap \
	-v /site/etc/$NAME:/ext/etc \
	-v /site/log/$NAME:/ext/log \
	-i \
	-t $TAG \
	/bin/bash

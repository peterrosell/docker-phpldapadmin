#!/bin/bash
SCRIPT_PATH=$(dirname `which $0`)
source $SCRIPT_PATH/env.sh

CMD="docker run \
	-d \
	--name $NAME \
	$@ \
	-p 10080:80 \
	--link openldap:ldap \
	-v /site/etc/$NAME:/ext/etc \
	-v /site/log/$NAME:/ext/log \
	-t $TAG"
echo $CMD

$CMD

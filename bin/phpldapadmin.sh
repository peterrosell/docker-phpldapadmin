#!/bin/bash

set -eu

status () {
  echo "---> ${@}" >&2
}


set -x

### Check if service shall be bootstrapped
if [ "$BOOTSTRAP" == "yes" ]; then


  CONFIG_FILE=/etc/phpldapadmin/config.php
  OLD_CONFIG_FILE=/tmp/config.php.original

  #LDAP_BASE=${LDAP_BASE}
  LDAP_HOST=`echo $LDAP_PORT | sed 's/tcp\:\/\/\(.*\):\(.*\)/\1/'`
  LDAP_HOST_PORT=`echo $LDAP_PORT | sed 's/tcp\:\/\/\(.*\):\(.*\)/\2/'`

  set +e
  test $(grep "${LDAP_BASE}" $CONFIG_FILE | wc -l) -gt 0
  RESULT=$?
  echo $RESULT
  set -e

  ############ Base config ############
  if [ "$RESULT" == "1" ]; then
    status "configuring php LDAP Admin"

    mkdir -p /etc/phpldapadmin
    cp -Rp /etc/phpldapadmin.original/* /etc/phpldapadmin

    mv ${CONFIG_FILE} ${OLD_CONFIG_FILE}
    cat ${OLD_CONFIG_FILE} \
    | sed "s/dc=example,dc=com/${LDAP_BASE}/g" \
    | sed "s/\('host'.*'\)127.0.0.1/\1${LDAP_HOST}/g" \
    | sed "s/\('port'.*'\)389/\1${LDAP_HOST_PORT}/g" \
    > ${CONFIG_FILE}
    chown --reference=${OLD_CONFIG_FILE} $CONFIG_FILE
    chmod --reference=${OLD_CONFIG_FILE} $CONFIG_FILE
    rm ${OLD_CONFIG_FILE}

  else
    status "PHP Ldap Admin already configured."
  fi
fi

/usr/sbin/apache2 -DFOREGROUND 

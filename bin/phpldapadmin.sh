#!/bin/sh

set -eu

status () {
  echo "---> ${@}" >&2
}


set -x

: LDAP_BASE=${LDAP_BASE}

############ Base config ############
if [ ! ( test $(grep "${LDAP_BASE}" config.php | wc -l) -gt 0 ) ]; then
  status "configuring php LDAP Admin"

  CONFIG_FILE=/etc/phpldapadmin/config.php
  OLD_CONFIG_FILE=/tmp/config.php.original

  mv ${CONFIG_FILE} ${OLD_CONFIG_FILE}
  sed "s/dc=example,dc=com/${LDAP_BASE}/g" ${OLD_CONFIG_FILE} > ${CONFIG_FILE}
  chown --reference=${OLD_CONFIG_FILE} $CONFIG_FILE
  chmod --reference=${OLD_CONFIG_FILE} $CONFIG_FILE
  rm ${OLD_CONFIG_FILE}

else
  status "slapd database found"
fi

/etc/init.d/apache2 start
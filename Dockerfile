FROM peterrosell/docker-ubuntu-base:trusty
MAINTAINER Peter Rosell <peter.rosell@gmail.com>

# Default configuration: can be overridden at the docker command line
ENV LDAP_BASE dc=biskvi,dc=net

### Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

ENV BOOTSTRAP no

# Expose ldap default port
EXPOSE 80

### INSTALL PHP LDAP ADMIN ###

### Work-around until version 1.2.2-5ubuntu2 or later is available 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:hellium/ppa

RUN apt-get -y update && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y phpldapadmin

### Remove the original phpldapadmin's directories and replace it with external volume
RUN mv /etc/phpldapadmin /etc/phpldapadmin.original

RUN mkdir -p /ext/etc
RUN mkdir -p /ext/log

RUN ln -s /ext/etc /etc/phpldapadmin
RUN ln -s /ext/log /var/log/apache2

ADD index.html /var/www/index.html
ADD bin/phpldapadmin.sh /usr/bin/phpldapadmin.sh

CMD /usr/bin/phpldapadmin.sh

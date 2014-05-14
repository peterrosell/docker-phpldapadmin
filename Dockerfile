FROM peterrosell/docker-openldap
MAINTAINER Peter Rosell <peter.rosell@gmail.com>

# Default configuration: can be overridden at the docker command line
ENV LDAP_BASE dc=biskvi,dc=net

# /!\ To store the data outside the container, mount /var/lib/ldap as a data volume
# add -v /some/host/directory:/var/lib/ldap to the run command

# Expose ldap default port
EXPOSE 80

### INSTALL PHP LDAP ADMIN ###

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:hellium/ppa

RUN apt-get -y update && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y phpldapadmin

ADD bin/phpldapadmin.sh /usr/bin/phpldapadmin.sh

CMD /usr/bin/phpldapadmin.sh
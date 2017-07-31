FROM rhel7:latest 
MAINTAINER Peter Czanik <peter.czanik@balabit.com>

#satisfy the label requirements
LABEL name="balabit/syslog-ng-ose" \
      vendor="Balabit" \
      version="3.10.1" \
      release="3" \
      summary="syslog-ng open source edition" \
      description="syslog-ng is an enhanced log daemon, supporting a wide range of input and output methods: syslog, unstructured text, message queues, databases (SQL and NoSQL alike) and more." \
      url="https://www.syslog-ng.org/" \
      run="docker run -d -v /data/syslog-ng/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v /data/syslog-ng/logs:/var/log -p 514:514 -p 601:601 --name container-syslog balabit/syslog-ng-ose"
#Be sure to make the appropriate directories on your host or the container will not run

#Atomic help file
COPY help.1 /help.1

### add licenses to this directory satisfy the cert scan for license
RUN mkdir -p /licenses
COPY licenses /licenses

#Install EPEL and auxillaries to satisfy the Syslog-NG software
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install curl ivykis ivykis-devel 

#Put the syslog-ng repo in place
COPY $PWD/czanik-syslog-ng310-epel-7.repo /etc/yum.repos.d/
RUN yum -y --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms \
      install syslog-ng syslog-ng-http syslog-ng-geoip syslog-ng-mongodb \
      syslog-ng-redis syslog-ng-smtp syslog-ng-python

#Satisfy all of the updat requirements for the cert scanner
RUN yum -y update-minimal --disablerepo "*" \
      --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms \
      --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical

#exposing ports that syslog-ng requires
EXPOSE 514/udp
EXPOSE 601/tcp
EXPOSE 6514/tcp

#Entrypoint for the container
ENTRYPOINT ["/usr/sbin/syslog-ng", "-F"]

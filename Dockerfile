FROM rhel7:latest 
MAINTAINER Peter Czanik <peter.czanik@balabit.com>

#satisfy the label requirements
LABEL name="rhel73/syslog-ng" \
      vendor="Syslog-NG" \
      version="3.10.1" \
      release="Opensource" 

#Be sure to make the appropriate directories on your host or the container will not run
LABEL run="docker run -d -v /data/syslog-ng/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v /data/syslog-ng/logs:/var/log -p 514:514 -p 601:601 --name container-syslog rhel73/syslog-ng-ose:3.10.1-1"
#Atomic help file
COPY help.1 /help.1

### add licenses to this directory satisfy the cert scan for license
RUN mkdir -p /licenses
COPY licenses /licenses

#Install EPEL and auxillaries to satisfy the Syslog-NG software
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install curl ivykis ivykis-devel 

#Put the syslog-ng repo in place
COPY $PWD/czanik-syslog-ng-githead-epel-7.repo /etc/yum.repos.d/
RUN yum -y --enablerepo rhel-7-server-rpms,rhel-7-server-optional-rpms install syslog-ng

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

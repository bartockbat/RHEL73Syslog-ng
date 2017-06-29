docker run -it -v /data/syslog-ng/conf/syslog-ng.conf:/etc/syslog-ng/syslog-ng.conf -v /data/syslog-ng/logs:/var/log -p 514:514 -p 601:601 --name glen-syslog rhel73/syslog-ng:3.5.6-3 -edv

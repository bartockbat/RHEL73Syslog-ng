# RHEL73Syslog-ng

This is a demo container for syslog-ng and Red Hat Enterprise 7.3

To build/run:

1. clone this repo on a registered RHEL7.3 host
2. build the image - docker build -t rhel73/syslog-ng:
3. be sure to create the appropriate directories on your host (See Dockerfile run statement)
4. launch the Dockerfile as per the run statement - you will see the syslog-ng running at the command line
5. to test - in a separate terminal window run the test command loggen -i -S -P localhost 601
6. you will see logging in the syslog-ng window
